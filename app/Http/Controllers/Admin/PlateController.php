<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Plate;
use Illuminate\Http\Request;

class PlateController extends Controller
{
    public function index()
    {
        $plates = Plate::when(request()->q, function ($plates) {
            $plates = $plates->where('type', 'like', '%' . request()->q . '%');
        })->latest()->paginate(10);

        $plates->appends(['q' => request()->q]);

        return inertia('Admin/Plates/Index', [
            'plates' => $plates,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'type'         => 'required',
            'description'  => 'nullable',
            'status'       => 'required',
        ]);

        Plate::create([
            'type'         => $request->type,
            'description'  => $request->description,
            'status'       => $request->status,
        ]);

        return redirect()->route('admin.plates.index');
    }

    public function update(Request $request, Plate $plate)
    {
        $request->validate([
            'type'         => 'required',
            'description'  => 'nullable',
            'status'       => 'required',
        ]);

        $plate->update([
            'type'         => $request->type,
            'description'  => $request->description,
            'status'       => $request->status,
        ]);

        return redirect()->route('admin.plates.index');
    }

    public function destroy($id)
    {
        $plate = Plate::findOrFail($id);
        $plate->delete();

        return redirect()->route('admin.plates.index');
    }
}
