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
        Schema::create('histories', function (Blueprint $table) {
            $table->id();
            $table->string('plate');
            $table->foreignId('rate_id')->references('id')->on('rates')->cascadeOnDelete();
            $table->integer('total_rate')->nullable();
            $table->dateTime('gate_in')->nullable();
            $table->dateTime('gate_out')->nullable();
            $table->enum('status', ['Temporary', 'Completed', 'Rejected']);

            $table->string('image_in');
            $table->float('processing_time_in');
            $table->float('confidence_in');
            $table->integer('x1_in');
            $table->integer('x2_in');
            $table->integer('y1_in');
            $table->integer('y2_in');

            $table->string('image_out')->nullable();;
            $table->float('processing_time_out')->nullable();;
            $table->float('confidence_out')->nullable();;
            $table->integer('x1_out')->nullable();;
            $table->integer('x2_out')->nullable();;
            $table->integer('y1_out')->nullable();;
            $table->integer('y2_out')->nullable();;

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('histories');
    }
};
