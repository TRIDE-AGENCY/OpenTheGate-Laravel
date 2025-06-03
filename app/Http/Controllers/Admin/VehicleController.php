<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Vehicle;
use Illuminate\Http\Request;

class VehicleController extends Controller
{
    public function index()
    {
        $vehicles = Vehicle::when(request()->q, function ($vehicles) {
            $vehicles = $vehicles->where('type', 'like', '%' . request()->q . '%');
        })->latest()->paginate(10);

        $vehicles->appends(['q' => request()->q]);

        return inertia('Admin/Vehicles/Index', [
            'vehicles' => $vehicles,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'type'         => 'required',
            'description'  => 'nullable',
            'status'       => 'required',
        ]);

        Vehicle::create([
            'type'         => $request->type,
            'description'  => $request->description,
            'status'       => $request->status,
        ]);

        return redirect()->route('admin.vehicles.index');
    }

    public function update(Request $request, Vehicle $vehicle)
    {
        $request->validate([
            'type'         => 'required',
            'description'  => 'nullable',
            'status'       => 'required',
        ]);

        $vehicle->update([
            'type'         => $request->type,
            'description'  => $request->description,
            'status'       => $request->status,
        ]);

        return redirect()->route('admin.vehicles.index');
    }

    public function destroy($id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $vehicle->delete();

        return redirect()->route('admin.vehicles.index');
    }
}
