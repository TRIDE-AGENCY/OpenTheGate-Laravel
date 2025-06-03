<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Carlist;
use App\Models\Rate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\RequestException;

class CarlistController extends Controller
{
    public function index()
    {
        $carlists = Carlist::when(request()->q, function ($carlists) {
            $carlists = $carlists->where('name', 'like', '%' . request()->q . '%');
        })->with('rate')->latest()->paginate(10);

        $carlists->appends(['q' => request()->q]);
        $rates = Rate::all();

        return inertia('Admin/Carlists/Index', [
            'carlists' => $carlists,
            'rates' => $rates,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'rate_id'     => 'required',
            'name'        => 'required',
            'plate'       => 'required',
            'start_date'  => 'required',
            'end_date'    => 'required',
            'description' => 'nullable',
            'status'      => 'required'
        ]);

        try {
            $rate = Rate::with(['vehicle', 'plate'])->find($request->rate_id);
            if (!$rate) {
                return redirect()->back()
                    ->withErrors(['rate_id' => 'Tarif parkir tidak ditemukan'])
                    ->withInput();
            }

            $response = Http::timeout(20)->get('https://samsat-api-v1.zeabur.app/check-plate', [
                'plate' => $request->plate
            ]);

            if ($response->successful()) {
                $data = $response->json();

                if (isset($data['status']) && $data['status'] === "Plat sudah terdaftar") {
                    $jenisKendaraanApi = $data['jenis_kendaraan'] ?? '';
                    $jenisPlatApi = $data['jenis_plat_nomor'] ?? '';

                    $jenisVehicleRate = $rate->vehicle->type ?? '';
                    $jenisPlateRate = $rate->plate->type ?? '';

                    $kendaraanMatch = stripos($jenisKendaraanApi, $jenisVehicleRate) !== false;
                    $platMatch = stripos($jenisPlatApi, $jenisPlateRate) !== false;

                    if (!$kendaraanMatch || !$platMatch) {
                        return redirect()->back()
                            ->withErrors(['rate_id' => 'Jenis kendaraan/plat tidak sesuai dengan tarif parkir yang dipilih'])
                            ->withInput();
                    }

                    Carlist::create([
                        'rate_id'     => $request->rate_id,
                        'name'        => $request->name,
                        'plate'       => $request->plate,
                        'start_date'  => $request->start_date,
                        'end_date'    => $request->end_date,
                        'description' => $request->description,
                        'status'      => $request->status,
                    ]);
                    return redirect()->route('admin.carlists.index');
                } else {
                    $errorMessage = $data['message'] ?? $data['status'] ?? 'Plat tidak valid atau tidak terdaftar di Samsat';
                    return redirect()->back()
                        ->withErrors(['plate' => $errorMessage])
                        ->withInput();
                }
            } else {
                $data = $response->json();
                $errorMessage = $data['message'] ?? 'Plat tidak valid atau tidak didukung';
                return redirect()->back()
                    ->withErrors(['plate' => $errorMessage])
                    ->withInput();
            }
        } catch (\Exception $e) {
            return redirect()->back()
                ->withErrors(['plate' => 'Terjadi kesalahan: ' . $e->getMessage()])
                ->withInput();
        }
    }

    public function update(Request $request, Carlist $carlist)
    {
        $request->validate([
            'rate_id'         => 'required',
            'name'            => 'required',
            'plate'           => 'required',
            'start_date'      => 'required',
            'end_date'        => 'required',
            'description'     => 'nullable',
            'status'          => 'required'
        ]);

        $carlist->update([
            'rate_id'         => $request->rate_id,
            'name'            => $request->name,
            'plate'           => $request->plate,
            'start_date'      => $request->start_date,
            'end_date'        => $request->end_date,
            'description'     => $request->description,
            'status'          => $request->status,
        ]);

        return redirect()->route('admin.carlists.index');
    }

    public function destroy($id)
    {
        $carlist = Carlist::findOrFail($id);
        $carlist->delete();

        return redirect()->route('admin.carlists.index');
    }
}
