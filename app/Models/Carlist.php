<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Carlist extends Model
{
    use HasFactory;

    protected $fillable = [
        'rate_id',
        'name',
        'plate',
        'start_date',
        'end_date',
        'description',
        'status',
    ];

    public function rate()
    {
        return $this->belongsTo(Rate::class);
    }

    public function histories()
    {
        return $this->hasMany(History::class);
    }
}
