<?php

use App\Http\Controllers\Admin\HistoryController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

Route::post('/admin/logout', function () {
    Auth::guard('web')->logout();
    request()->session()->forget('web');
    request()->session()->regenerateToken();
    return redirect('/login');
})->name('admin.logout');

Route::prefix('admin')->group(function () {
    Route::group(['middleware' => ['auth']], function () {
        Route::get('/dashboard', App\Http\Controllers\Admin\DashboardController::class)->name('admin.dashboard');
        Route::resource('/histories', \App\Http\Controllers\Admin\HistoryController::class, ['as' => 'admin']);
        Route::resource('/carlists', \App\Http\Controllers\Admin\CarlistController::class, ['as' => 'admin']);
        Route::resource('/rates', \App\Http\Controllers\Admin\RateController::class, ['as' => 'admin']);
        Route::resource('/vehicles', \App\Http\Controllers\Admin\VehicleController::class, ['as' => 'admin']);
        Route::resource('/plates', \App\Http\Controllers\Admin\PlateController::class, ['as' => 'admin']);
        Route::resource('/user', \App\Http\Controllers\Admin\UserController::class, ['as' => 'admin']);

        Route::put('/admin/histories/update-gate-out', [HistoryController::class, 'updateGateOut'])->name('admin.histories.updateGateOut');
    });
});
