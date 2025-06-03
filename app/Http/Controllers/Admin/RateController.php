<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Plate;
use App\Models\Rate;
use App\Models\Vehicle;
use Illuminate\Http\Request;

class RateController extends Controller
{
    public function index()
    {
        $rates = Rate::when(request()->q, function ($rates) {
            $rates = $rates->where('name', 'like', '%' . request()->q . '%');
        })->with('vehicle', 'plate')->latest()->paginate(10);

        $rates->appends(['q' => request()->q]);
        $vehicles = Vehicle::all();
        $plates = Plate::all();

        return inertia('Admin/Rates/Index', [
            'rates' => $rates,
            'vehicles' => $vehicles,
            'plates' => $plates,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'vehicle_id'      => 'required',
            'plate_id'        => 'required',
            'name'            => 'required',
            'type'            => 'required',
            'flat_rate'       => 'nullable',
            'first_hour_rate' => 'nullable',
            'next_hour_rate'  => 'nullable',
            'max_hour_rate'   => 'nullable',
            'description'     => 'nullable',
            'status'          => 'required'
        ]);

        Rate::create([
            'vehicle_id'      => $request->vehicle_id,
            'plate_id'        => $request->plate_id,
            'name'            => $request->name,
            'type'            => $request->type,
            'flat_rate'       => $request->flat_rate,
            'first_hour_rate' => $request->first_hour_rate,
            'next_hour_rate'  => $request->next_hour_rate,
            'max_hour_rate'   => $request->max_hour_rate,
            'description'     => $request->description,
            'status'          => $request->status,
        ]);

        return redirect()->route('admin.rates.index');
    }

    public function update(Request $request, Rate $rate)
    {
        $request->validate([
            'vehicle_id'      => 'required',
            'plate_id'        => 'required',
            'name'            => 'required',
            'type'            => 'required',
            'flat_rate'       => 'nullable',
            'first_hour_rate' => 'nullable',
            'next_hour_rate'  => 'nullable',
            'max_hour_rate'   => 'nullable',
            'description'     => 'nullable',
            'status'          => 'required'
        ]);

        $rate->update([
            'vehicle_id'      => $request->vehicle_id,
            'plate_id'        => $request->plate_id,
            'name'            => $request->name,
            'type'            => $request->type,
            'flat_rate'       => $request->flat_rate,
            'first_hour_rate' => $request->first_hour_rate,
            'next_hour_rate'  => $request->next_hour_rate,
            'max_hour_rate'   => $request->max_hour_rate,
            'description'     => $request->description,
            'status'          => $request->status,
        ]);

        return redirect()->route('admin.rates.index');
    }

    public function destroy($id)
    {
        $rate = Rate::findOrFail($id);
        $rate->delete();

        return redirect()->route('admin.rates.index');
    }
}
