<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('rates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vehicle_id')->references('id')->on('vehicles')->cascadeOnDelete();
            $table->foreignId('plate_id')->references('id')->on('plates')->cascadeOnDelete();
            $table->string('name');
            $table->enum('type', ['Flat', 'Per Jam']);
            $table->integer('flat_rate')->nullable();
            $table->integer('first_hour_rate')->nullable();
            $table->integer('next_hour_rate')->nullable();
            $table->integer('max_hour_rate')->nullable();
            $table->text('description')->nullable();
            $table->enum('status', ['Y', 'N'])->default('Y');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rates');
    }
};
