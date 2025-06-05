<?php

use App\Http\Controllers\Admin\HistoryController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

// Root route - redirect to login
Route::get('/', function () {
    return redirect('/login');
});

// Debug route to check/create users
Route::get('/debug-users', function () {
    echo "<h2>🔍 Database Users Debug</h2>";
    
    try {
        // Check existing users
        $users = DB::table('users')->select('id', 'name', 'email', 'created_at')->get();
        
        echo "<h3>📋 Existing Users:</h3>";
        if ($users->count() > 0) {
            echo "<table border='1' style='border-collapse: collapse; margin: 10px 0;'>";
            echo "<tr><th>ID</th><th>Name</th><th>Email</th><th>Created</th></tr>";
            foreach ($users as $user) {
                echo "<tr>";
                echo "<td>{$user->id}</td>";
                echo "<td>{$user->name}</td>";
                echo "<td>{$user->email}</td>";
                echo "<td>{$user->created_at}</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>❌ No users found in database</p>";
        }
        
        // Create admin user if doesn't exist
        $adminEmail = 'admin@bss-parking.com';
        $existingAdmin = User::where('email', $adminEmail)->first();
        
        if (!$existingAdmin) {
            echo "<h3>🔧 Creating Admin User:</h3>";
            $admin = User::create([
                'name' => 'BSS Admin',
                'email' => $adminEmail,
                'password' => Hash::make('admin123'),
                'email_verified_at' => now(),
            ]);
            echo "<p>✅ Admin user created:</p>";
            echo "<p><strong>Email:</strong> {$adminEmail}</p>";
            echo "<p><strong>Password:</strong> admin123</p>";
        } else {
            echo "<h3>✅ Admin User Exists:</h3>";
            echo "<p><strong>Email:</strong> {$existingAdmin->email}</p>";
            echo "<p><strong>Name:</strong> {$existingAdmin->name}</p>";
        }
        
        // Reset password for agency.tride@gmail.com if exists
        $trideUser = User::where('email', 'agency.tride@gmail.com')->first();
        if ($trideUser) {
            $trideUser->password = Hash::make('tride123');
            $trideUser->save();
            echo "<h3>🔑 Reset Password for agency.tride@gmail.com:</h3>";
            echo "<p><strong>Email:</strong> agency.tride@gmail.com</p>";
            echo "<p><strong>New Password:</strong> tride123</p>";
        }
        
    } catch (Exception $e) {
        echo "<p>❌ Error: " . $e->getMessage() . "</p>";
    }
    
    echo "<br><a href='/login'>🔙 Back to Login</a>";
});

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
