<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    use HasFactory;

    protected $fillable = [
        'type',
        'description',
        'status',
    ];

    public function rates()
    {
        return $this->hasMany(Rate::class);
    }
}
