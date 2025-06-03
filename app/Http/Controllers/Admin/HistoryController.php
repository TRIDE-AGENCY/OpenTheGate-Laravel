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
        $history = History::with(['rate.vehicle', 'rate.plate'])->findOrFail($id);

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
            'image_in.image' => 'Gambar soal harus berupa file gambar.',
            'image_in.mimes' => 'Gambar soal harus berekstensi jpg, jpeg, atau png.',
            'image_in.max' => 'Ukuran gambar soal maksimal 2MB.',
        ]);

        $localPath = $request->file('image_in')->store('temp', 'public');
        $fullPath = storage_path('app/public/' . $localPath);

        $response = Http::attach(
            'image',
            file_get_contents($fullPath),
            $request->file('image_in')->getClientOriginalName()
        )->post('https://plates-numbers-ocr.zeabur.app/api/recognize');

        if (!$response->successful()) {
            return back()->withErrors(['image_in' => 'Gagal mengirim gambar ke API OCR.']);
        }

        $data = $response->json();

        if (!$data['success'] || empty($data['detections'])) {
            return back()->withErrors(['image_in' => 'Plat nomor tidak berhasil dikenali.']);
        }

        $detection = $data['detections'][0];
        $plate = str_replace(' ', '', $detection['raw_text']);
        $rate = null;

        $today = Carbon::today();
        $car = Carlist::get()->first(function ($item) use ($plate, $today) {
            $plateDb = str_replace(' ', '', $item->plate);
            return $plateDb === $plate &&
                $today->between(Carbon::parse($item->start_date), Carbon::parse($item->end_date));
        });

        $is_blacklisted = false;
        if ($car) {
            if ($car->status === 'N') {
                $is_blacklisted = true;
            }

            $rate = Rate::find($car->rate_id);
            if (!$rate) {
                return back()->withErrors(['image_in' => "Plat $plate ditemukan di kendaraan terdaftar, tapi tarif parkirnya tidak ditemukan."]);
            }
        } else {
            $samsatResponse = Http::timeout(20)->get('https://samsat-api-v1.zeabur.app/check-plate', [
                'plate' => $plate
            ]);

            $samsatData = $samsatResponse->json();

            $errorMessage = $samsatData['message'] ?? $samsatData['status'] ?? '';

            $unsupportedFormats = [
                "Format plat dinas negara tidak didukung oleh database",
                "Format plat diplomatik tidak didukung oleh database",
            ];

            if (
                !$samsatResponse->successful() ||
                !isset($samsatData['status']) ||
                $samsatData['status'] !== 'Plat sudah terdaftar'
            ) {
                if (in_array($errorMessage, $unsupportedFormats)) {
                    $jenisKendaraanApi = "Mobil Penumpang";
                    $jenisPlatApi = $samsatData['jenis_plat_nomor'] ?? '';
                } else {
                    return back()->withErrors(['image_in' => "Plat $plate gagal diverifikasi. $errorMessage"]);
                }
            } else {
                $jenisKendaraanApi = $samsatData['jenis_kendaraan'] ?? '';
                $jenisPlatApi = $samsatData['jenis_plat_nomor'] ?? '';
            }

            $rate = Rate::with(['vehicle', 'plate'])->get()->first(function ($item) use ($jenisKendaraanApi, $jenisPlatApi) {
                $kendaraanMatch = stripos($jenisKendaraanApi, $item->vehicle->type ?? '') !== false;
                $platMatch = stripos($jenisPlatApi, $item->plate->type ?? '') !== false;
                return $kendaraanMatch && $platMatch;
            });

            if (!$rate) {
                return back()->withErrors([
                    'image_in' => "Plat $plate berhasil dikenali, tapi tarif parkirnya tidak ditemukan."
                ]);
            }
        }

        if (strtolower($jenisPlatApi) === 'sipil') {
            $plate = str_replace('-', '', $plate);
        }

        $existingHistory = History::whereRaw("REPLACE(plate, ' ', '') = ?", [$plate])
            ->whereIn('status', ['Temporary'])
            ->latest()
            ->first();

        $image_in_path = $request->file('image_in')->store('histories', 'public');

        if ($existingHistory) {
            $totalRate = $this->calculateTotalRate($existingHistory->rate, $existingHistory->gate_in, $is_blacklisted ? null : now());
            // Update data yang sudah ada
            $existingHistory->update([
                'total_rate'          => $totalRate,
                'status'              => 'Completed',
                'gate_out'            => $is_blacklisted ? null : now(),
                'image_out'           => $image_in_path,
                'processing_time_out' => $data['processing_time'],
                'confidence_out'      => $detection['confidence']['overall'],
                'x1_out'              => $detection['bounding_box']['x1'],
                'x2_out'              => $detection['bounding_box']['x2'],
                'y1_out'              => $detection['bounding_box']['y1'],
                'y2_out'              => $detection['bounding_box']['y2'],
            ]);

            return Inertia::location(route('admin.histories.show', $existingHistory->id));
        } else {
            $history = History::create([
                'plate'               => $plate,
                'rate_id'             => $rate->id,
                'total_rate'          => null,
                'gate_in'             => now(),
                'gate_out'            => null,
                'status'              => $is_blacklisted ? 'Rejected' : 'Temporary',
                'image_in'            => $image_in_path,
                'processing_time_in'  => $data['processing_time'],
                'confidence_in'       => $detection['confidence']['overall'],
                'x1_in'               => $detection['bounding_box']['x1'],
                'x2_in'               => $detection['bounding_box']['x2'],
                'y1_in'               => $detection['bounding_box']['y1'],
                'y2_in'               => $detection['bounding_box']['y2'],
                'image_out'           => null,
                'processing_time_out' => null,
                'confidence_out'      => null,
                'x1_out'              => null,
                'x2_out'              => null,
                'y1_out'              => null,
                'y2_out'              => null,
            ]);

            return Inertia::location(route('admin.histories.show', $history->id));
        }
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
        $history->delete();

        return redirect()->route('admin.histories.index');
    }
}
