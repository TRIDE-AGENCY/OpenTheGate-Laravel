<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Rate extends Model
{
    use HasFactory;

    protected $fillable = [
        'vehicle_id',
        'plate_id',
        'name',
        'type',
        'flat_rate',
        'first_hour_rate',
        'next_hour_rate',
        'max_hour_rate',
        'description',
        'status',
    ];

    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class);
    }

    public function plate()
    {
        return $this->belongsTo(Plate::class);
    }

    public function carlists()
    {
        return $this->hasMany(Carlist::class);
    }
}
