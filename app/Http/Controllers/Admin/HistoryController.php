<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Carlist;
use App\Models\History;
use App\Models\Rate;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class HistoryController extends Controller
{
    public function index()
    {
        $histories = History::when(request()->q, function ($histories) {
            $histories = $histories->where('plate', 'like', '%' . request()->q . '%');
        })->with('rate')->latest()->paginate(10);

        $histories->appends(['q' => request()->q]);
        $rates = Rate::all();

        return inertia('Admin/Histories/Index', [
            'histories' => $histories,
            'rates' => $rates,
        ]);
    }

    public function show($id)
    {
        $history = History::with(['rate.vehicle', 'rate.plate', 'carlist'])->findOrFail($id);

        return inertia('Admin/Histories/Show', [
            'history' => $history,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'image_in' => 'required|image|mimes:jpg,jpeg,png|max:20000',
        ], [
            'image_in.required' => 'Harap masukkan gambar terlebih dahulu.',
            'image_in.image' => 'Gambar harus berupa file gambar.',
            'image_in.mimes' => 'Gambar harus berekstensi jpg, jpeg, atau png.',
            'image_in.max' => 'Ukuran gambar maksimal 2MB.',
        ]);

        // Simpan gambar langsung ke folder histories
        $imageFile = $request->file('image_in');
        $imagePath = $imageFile->store('histories', 'public');

        // Kirim gambar ke API OCR
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . env('OCR_API_TOKEN'),
        ])->attach(
            'file',
            file_get_contents($imageFile->getRealPath()),
            $imageFile->getClientOriginalName()
        )->asMultipart()->post('https://plates-number-recognition-v2.zeabur.app/recognize', [
            'confidence_threshold' => 0.7
        ]);

        if (!$response->successful()) {
            Storage::disk('public')->delete($imagePath);
            return back()->withErrors(['image_in' => 'Gagal mengirim gambar ke API OCR.']);
        }

        $data = $response->json();
        if (empty($data['detections'])) {
            Storage::disk('public')->delete($imagePath);
            return back()->withErrors(['image_in' => 'Plat nomor tidak dikenali.']);
        }

        $detection = $data['detections'][0];
        $plate = str_replace(' ', '', $detection['license_plate']);
        
        // Format plate number: convert • to - (example: 50072•00 -> 50072-00)
        $formattedPlate = str_replace('•', '-', $plate);

        // ====== Cek apakah kendaraan terdaftar ======
        $today = Carbon::today();
        $car = Carlist::get()->first(function ($item) use ($formattedPlate, $today) {
            $cleaned = fn($p) => strtoupper(str_replace([' ', '-'], '', $p));
            return $cleaned($item->plate) === $cleaned($formattedPlate)
                && $today->between(Carbon::parse($item->start_date), Carbon::parse($item->end_date));
        });

        $rate = null;
        $carlistId = $car?->id;
        $is_blacklisted = $car?->status === 'N';

        // ====== Cek tarif dari database atau API samsat ======
        if ($car) {
            $rate = Rate::find($car->rate_id);
            if (!$rate) {
                Storage::disk('public')->delete($imagePath);
                return back()->withErrors(["image_in" => "Tarif untuk plat $formattedPlate tidak ditemukan."]);
            }
        } else {
            $samsatResponse = Http::withHeaders([
                'Authorization' => 'Bearer ' . env('SAMSAT_API_TOKEN'),
            ])->get('https://samsat-api-v2.zeabur.app/check-plate', ['plate' => $formattedPlate]);

            $samsatData = $samsatResponse->json();
            $errorMessage = $samsatData['message'] ?? $samsatData['status'] ?? '';
            $jenisKendaraanApi = $samsatData['jenis_kendaraan'] ?? '';
            $jenisPlatApi = $samsatData['jenis_plat_nomor'] ?? '';

            $unsupported = [
                "Format plat dinas negara tidak didukung oleh database",
                "Format plat diplomatik tidak didukung oleh database",
            ];

            if (
                !$samsatResponse->successful() ||
                !in_array($samsatData['status'] ?? '', ['Plat sudah terdaftar', 'Format plat militer lama terdeteksi'])
            ) {
                if (!in_array($errorMessage, $unsupported)) {
                    Storage::disk('public')->delete($imagePath);
                    return back()->withErrors(["image_in" => "Plat $formattedPlate gagal diverifikasi. $errorMessage"]);
                } else if (in_array($errorMessage, $unsupported)) {
                    $jenisKendaraanApi = "Mobil Penumpang";
                    $jenisPlatApi = $samsatData['jenis_plat_nomor'] ?? '';
                }
            }

            $rate = Rate::with(['vehicle', 'plate'])->get()->first(function ($item) use ($jenisKendaraanApi, $jenisPlatApi) {
                return stripos($jenisKendaraanApi, $item->vehicle->type ?? '') !== false &&
                    stripos($jenisPlatApi, $item->plate->type ?? '') !== false;
            });

            if (!$rate) {
                Storage::disk('public')->delete($imagePath);
                return back()->withErrors(["image_in" => "Tarif untuk plat $formattedPlate tidak ditemukan."]);
            }
        }

        // ====== Cek history jika sebelumnya belum keluar ======
        $existingHistory = History::whereRaw("REPLACE(plate, ' ', '') = ?", [$formattedPlate])
            ->where('status', 'Temporary')->latest()->first();

        if ($existingHistory) {
            $existingHistory->update([
                'total_rate'          => $this->calculateTotalRate($rate, $existingHistory->gate_in, $is_blacklisted ? null : now()),
                'status'              => 'Completed',
                'gate_out'            => $is_blacklisted ? null : now(),
                'image_out'           => $imagePath,
                'processing_time_out' => $data['processing_time_seconds'],
                'confidence_out'      => $detection['confidence'],
                'x1_out'              => $detection['bounding_box']['x1'],
                'x2_out'              => $detection['bounding_box']['x2'],
                'y1_out'              => $detection['bounding_box']['y1'],
                'y2_out'              => $detection['bounding_box']['y2'],
            ]);

            return Inertia::location(route('admin.histories.show', $existingHistory->id));
        }

        $history = History::create([
            'plate'               => $formattedPlate,
            'rate_id'             => $rate->id,
            'carlist_id'          => $carlistId,
            'total_rate'          => null,
            'gate_in'             => now(),
            'status'              => $is_blacklisted ? 'Rejected' : 'Temporary',
            'image_in'            => $imagePath,
            'processing_time_in'  => $data['processing_time_seconds'],
            'confidence_in'       => $detection['confidence'],
            'x1_in'               => $detection['bounding_box']['x1'],
            'x2_in'               => $detection['bounding_box']['x2'],
            'y1_in'               => $detection['bounding_box']['y1'],
            'y2_in'               => $detection['bounding_box']['y2'],
        ]);

        return Inertia::location(route('admin.histories.show', $history->id));
    }

    function calculateTotalRate($rate, $gateIn, $gateOut = null)
    {
        if (!$gateIn instanceof Carbon) {
            $gateIn = Carbon::parse($gateIn);
        }

        if ($gateOut === null) {
            $gateOut = Carbon::now();
        } elseif (!$gateOut instanceof Carbon) {
            $gateOut = Carbon::parse($gateOut);
        }

        $durationMinutes = $gateIn->diffInMinutes($gateOut);

        if ($durationMinutes < 5) {
            return 0;
        }

        if ($rate->type === 'Flat') {
            return $rate->flat_rate ?? 0;
        }

        if ($rate->type === 'Per Jam') {
            $hours = ceil($durationMinutes / 60);

            if ($hours <= 1) {
                return $rate->first_hour_rate ?? 0;
            }

            $total = ($rate->first_hour_rate ?? 0) + (($hours - 1) * ($rate->next_hour_rate ?? 0));

            if ($rate->max_hour_rate !== null && $hours >= 23 && $total > $rate->max_hour_rate) {
                return $rate->max_hour_rate;
            }

            return $total;
        }

        return 0;
    }

    public function destroy($id)
    {
        $history = History::findOrFail($id);

        foreach (['image_in', 'image_out'] as $field) {
            if ($history->$field && Storage::disk('public')->exists($history->$field)) {
                Storage::disk('public')->delete($history->$field);
            }
        }

        $history->delete();

        return redirect()->route('admin.histories.index');
    }
}
