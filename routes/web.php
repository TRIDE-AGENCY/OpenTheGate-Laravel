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

// Debug route to check storage and images
Route::get('/debug-storage', function () {
    echo "<h2>🖼️ Storage & Images Debug</h2>";
    
    try {
        // Check if storage link exists
        echo "<h3>🔗 Storage Link Status:</h3>";
        $storageLinkPath = public_path('storage');
        if (is_link($storageLinkPath)) {
            echo "<p>✅ Storage symlink exists</p>";
            echo "<p><strong>Target:</strong> " . readlink($storageLinkPath) . "</p>";
        } else {
            echo "<p>❌ Storage symlink does NOT exist</p>";
            echo "<p><strong>Expected path:</strong> $storageLinkPath</p>";
        }
        
        // Check storage directories
        echo "<h3>📁 Storage Directories:</h3>";
        $directories = [
            'storage/app/public' => storage_path('app/public'),
            'storage/app/public/images' => storage_path('app/public/images'),
            'storage/app/public/vehicles' => storage_path('app/public/vehicles'),
            'storage/app/public/plates' => storage_path('app/public/plates'),
            'public/storage' => public_path('storage'),
        ];
        
        foreach ($directories as $name => $path) {
            if (is_dir($path)) {
                echo "<p>✅ $name exists</p>";
                $files = scandir($path);
                $fileCount = count($files) - 2; // subtract . and ..
                echo "<p>&nbsp;&nbsp;&nbsp;Files: $fileCount</p>";
                if ($fileCount > 0 && $fileCount < 20) {
                    echo "<p>&nbsp;&nbsp;&nbsp;Contents: " . implode(', ', array_slice($files, 2)) . "</p>";
                }
            } else {
                echo "<p>❌ $name does NOT exist</p>";
            }
        }
        
        // Check database for image references
        echo "<h3>🗄️ Database Image References:</h3>";
        
        // Check histories table for car_image_path
        $histories = DB::table('histories')
            ->select('id', 'license_plate', 'car_image_path', 'created_at')
            ->whereNotNull('car_image_path')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();
            
        if ($histories->count() > 0) {
            echo "<p>✅ Found {$histories->count()} records with car images in histories table:</p>";
            echo "<table border='1' style='border-collapse: collapse; margin: 10px 0;'>";
            echo "<tr><th>ID</th><th>License Plate</th><th>Image Path</th><th>File Exists</th><th>Public Access</th></tr>";
            foreach ($histories as $history) {
                $imagePath = $history->car_image_path;
                $fullPath = storage_path('app/public/' . $imagePath);
                $publicPath = public_path('storage/' . $imagePath);
                $fileExists = file_exists($fullPath) ? '✅' : '❌';
                $publicExists = file_exists($publicPath) ? '✅' : '❌';
                
                echo "<tr>";
                echo "<td>{$history->id}</td>";
                echo "<td>{$history->license_plate}</td>";
                echo "<td>{$imagePath}</td>";
                echo "<td>{$fileExists}</td>";
                echo "<td>{$publicExists}</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>❌ No records with car images found in histories table</p>";
        }
        
        // Check vehicles table for image_path
        $vehicles = DB::table('vehicles')
            ->select('id', 'license_plate', 'image_path', 'created_at')
            ->whereNotNull('image_path')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();
            
        if ($vehicles->count() > 0) {
            echo "<p>✅ Found {$vehicles->count()} records with images in vehicles table:</p>";
            echo "<table border='1' style='border-collapse: collapse; margin: 10px 0;'>";
            echo "<tr><th>ID</th><th>License Plate</th><th>Image Path</th><th>File Exists</th></tr>";
            foreach ($vehicles as $vehicle) {
                $imagePath = $vehicle->image_path;
                $fullPath = storage_path('app/public/' . $imagePath);
                $fileExists = file_exists($fullPath) ? '✅' : '❌';
                
                echo "<tr>";
                echo "<td>{$vehicle->id}</td>";
                echo "<td>{$vehicle->license_plate}</td>";
                echo "<td>{$imagePath}</td>";
                echo "<td>{$fileExists}</td>";
                echo "</tr>";
            }
            echo "</table>";
        } else {
            echo "<p>❌ No records with images found in vehicles table</p>";
        }
        
        // Test image URLs
        echo "<h3>🌐 Image URL Testing:</h3>";
        $testImagePath = 'test-image.txt';
        $storageUrl = asset('storage/' . $testImagePath);
        echo "<p><strong>Test image URL:</strong> <a href='$storageUrl' target='_blank'>$storageUrl</a></p>";
        
        // Show recent histories with image paths for reference
        $recentHistories = DB::table('histories')
            ->select('license_plate', 'car_image_path')
            ->whereNotNull('car_image_path')
            ->orderBy('id', 'desc')
            ->limit(3)
            ->get();
            
        if ($recentHistories->count() > 0) {
            echo "<h3>📋 Recent History Image URLs:</h3>";
            foreach ($recentHistories as $history) {
                $imageUrl = asset('storage/' . $history->car_image_path);
                echo "<p><strong>{$history->license_plate}:</strong> <a href='$imageUrl' target='_blank'>$imageUrl</a></p>";
            }
        }
        
    } catch (Exception $e) {
        echo "<p>❌ Error: " . $e->getMessage() . "</p>";
    }
    
    echo "<br><a href='/login'>🔙 Back to Login</a> | <a href='/debug-users'>👥 Debug Users</a>";
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
