<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class History extends Model
{
    use HasFactory;

    protected $fillable = [
        'plate',
        'rate_id',
        'carlist_id',
        'total_rate',
        'gate_in',
        'gate_out',
        'status',

        'image_in',
        'processing_time_in',
        'confidence_in',
        'x1_in',
        'x2_in',
        'y1_in',
        'y2_in',

        'image_out',
        'processing_time_out',
        'confidence_out',
        'x1_out',
        'x2_out',
        'y1_out',
        'y2_out',
    ];

    public function rate()
    {
        return $this->belongsTo(Rate::class);
    }

    public function carlist()
    {
        return $this->belongsTo(Carlist::class);
    }
}
