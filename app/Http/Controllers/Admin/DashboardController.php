<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\History;
use App\Models\Vehicle;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function __invoke(Request $request)
    {
        $totalPendapatan = History::sum('total_rate');
        $kendaraanMasuk = History::whereNotNull('gate_in')->count();
        $kendaraanKeluar = History::whereNotNull('gate_out')->count();

        $statusCounts = History::select('status', DB::raw('count(*) as total'))
            ->groupBy('status')
            ->pluck('total', 'status')
            ->toArray();

        $statusData = [
            'Temporary' => $statusCounts['Temporary'] ?? 0,
            'Completed' => $statusCounts['Completed'] ?? 0,
            'Rejected'  => $statusCounts['Rejected'] ?? 0,
        ];

        $allVehicles = Vehicle::pluck('type')->toArray();
        $vehicleCountsRaw = History::join('rates', 'histories.rate_id', '=', 'rates.id')
            ->join('vehicles', 'rates.vehicle_id', '=', 'vehicles.id')
            ->select('vehicles.type', DB::raw('count(histories.id) as total'))
            ->groupBy('vehicles.type')
            ->pluck('total', 'vehicles.type')
            ->toArray();

        // Pastikan semua jenis kendaraan ada di array, isi 0 jika tidak ada count
        $vehicleTypeCounts = [];
        foreach ($allVehicles as $type) {
            $vehicleTypeCounts[$type] = $vehicleCountsRaw[$type] ?? 0;
        }

        // --- Line chart per jam: kendaraan masuk (gate_in) dan keluar (gate_out) ---

        // Format jam: "HH:00" (contoh: 13:00)
        // Misal kita ambil data hari ini, jam 0 sampai 23
        // Array jam 00:00 sampai 23:00
        $hours = [];
        for ($h = 0; $h < 24; $h++) {
            $hours[] = str_pad($h, 2, '0', STR_PAD_LEFT) . ':00';
        }

        // Query kendaraan masuk per jam, untuk semua tanggal
        $gateInPerHour = History::select(
            DB::raw('HOUR(gate_in) as hour'),
            DB::raw('count(*) as total')
        )
            ->whereNotNull('gate_in') // Pastikan gate_in tidak null
            ->groupBy('hour')
            ->pluck('total', 'hour')
            ->toArray();

        // Query kendaraan keluar per jam, untuk semua tanggal
        $gateOutPerHour = History::select(
            DB::raw('HOUR(gate_out) as hour'),
            DB::raw('count(*) as total')
        )
            ->whereNotNull('gate_out') // Pastikan gate_out tidak null
            ->groupBy('hour')
            ->pluck('total', 'hour')
            ->toArray();

        // Siapkan data 24 jam, isi 0 bila tidak ada data
        $gateInData = [];
        $gateOutData = [];
        for ($h = 0; $h < 24; $h++) {
            $gateInData[] = $gateInPerHour[$h] ?? 0;
            $gateOutData[] = $gateOutPerHour[$h] ?? 0;
        }


        $latestHistories = History::with('rate.vehicle')
            ->latest()
            ->limit(5)
            ->get();

        return inertia('Admin/Dashboard/Index', [
            'totalPendapatan' => $totalPendapatan,
            'kendaraanMasuk' => $kendaraanMasuk,
            'kendaraanKeluar' => $kendaraanKeluar,
            'statusData' => $statusData,
            'vehicleTypeCounts' => $vehicleTypeCounts,
            'hourLabels' => $hours,
            'gateInData' => $gateInData,
            'gateOutData' => $gateOutData,
            'latestHistories' => $latestHistories,
        ]);
    }
}
