#!/bin/sh

# Zeabur-optimized startup script for Laravel

echo "🚀 Starting BSS Parking System on Zeabur..."

# Set environment variables with Zeabur MySQL configuration
export DB_HOST="43.153.199.217"
export DB_PORT="32628"
export DB_DATABASE="db_bss_parking"
export DB_USERNAME="root"
export DB_PASSWORD="E384qheG5ioSw6fbHZ01kDxa9uKQ2cj7"

echo "🔍 Database configuration:"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "Database: $DB_DATABASE"
echo "Username: $DB_USERNAME"

# Create .env file
echo "📝 Creating Laravel configuration..."
cat > /var/www/html/.env << EOF
APP_NAME="BSS Parking"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://bss-parking-tride.zeabur.app
FORCE_HTTPS=true
ASSET_URL=https://bss-parking-tride.zeabur.app

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
DB_DATABASE=${DB_DATABASE}
DB_USERNAME=${DB_USERNAME}
DB_PASSWORD=${DB_PASSWORD}

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
EOF

# Generate app key
echo "🔑 Generating application key..."
php artisan key:generate --force

# Force HTTPS for all URLs
echo "🔒 Configuring HTTPS..."
php artisan tinker --execute="
\Illuminate\Support\Facades\URL::forceScheme('https');
\Illuminate\Support\Facades\URL::forceRootUrl('https://bss-parking-tride.zeabur.app');
echo 'HTTPS forced for all URLs';
"

# Verify Laravel configuration
echo "🔍 Verifying Laravel configuration..."
php artisan config:show app.key || echo "App key check failed"
php artisan env || echo "Environment check failed"

# Test database connection
echo "⏳ Testing database connection..."
DATABASE_READY=false

# Try connection with different methods
for attempt in 1 2 3 4 5; do
    echo "Attempt $attempt/5..."
    
    # First ensure the database exists
    if MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -e "CREATE DATABASE IF NOT EXISTS \`$DB_DATABASE\`;" 2>/dev/null; then
        echo "✅ Database '$DB_DATABASE' exists or created!"
        
        # Method 1: Using MYSQL_PWD environment variable
        if MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -e "SELECT 1;" "$DB_DATABASE" >/dev/null 2>&1; then
            echo "✅ Database connection successful!"
            DATABASE_READY=true
            break
        fi
        
        # Method 2: Using --password flag
        if mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" --password="$DB_PASSWORD" -e "SELECT 1;" "$DB_DATABASE" >/dev/null 2>&1; then
            echo "✅ Database connection successful!"
            DATABASE_READY=true
            break
        fi
    fi
    
    echo "⏳ Connection failed, waiting 5 seconds..."
    sleep 5
done

# Import database if connected and empty
if [ "$DATABASE_READY" = true ]; then
    echo "🗄️ Checking database tables..."
    
    # Check if tables exist
    TABLE_COUNT=$(MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_DATABASE';" "$DB_DATABASE" 2>/dev/null | tail -1)
    
    if [ "$TABLE_COUNT" = "0" ] || [ -z "$TABLE_COUNT" ]; then
        echo "�� Database is empty, setting up from scratch..."
        
        # Try to import SQL file first
        if [ -f "/var/www/html/db_bss_parking.sql" ]; then
            echo "📥 Importing database schema from SQL file..."
            MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" "$DB_DATABASE" < /var/www/html/db_bss_parking.sql
            if [ $? -eq 0 ]; then
                echo "✅ Database schema imported successfully!"
            else
                echo "⚠️ SQL import failed, using Laravel migrations..."
                php artisan migrate --force
                echo "🌱 Running database seeders..."
                php artisan db:seed --class="DatabaseSeeder" --force || echo "Seeding failed or no seeders found"
            fi
        else
            echo "⚠️ SQL file not found, using Laravel setup..."
            echo "🔄 Running database migrations..."
            php artisan migrate --force
            echo "🌱 Running database seeders..."
            php artisan db:seed --class="DatabaseSeeder" --force || echo "Seeding failed or no seeders found"
        fi
    else
        echo "✅ Database tables already exist ($TABLE_COUNT tables)"
        echo "🔄 Running migrations to ensure up-to-date schema..."
        php artisan migrate --force || echo "Migration check failed"
    fi
else
    echo "⚠️ Database not ready, but starting web server anyway..."
    echo "You may need to set up the database manually later."
fi

# Laravel setup as per README
echo "🔗 Creating storage link..."
php artisan storage:link --force || true

# Ensure proper storage permissions for images
echo "📸 Setting up image storage..."
mkdir -p /var/www/html/storage/app/public/images
mkdir -p /var/www/html/storage/app/public/vehicles
mkdir -p /var/www/html/storage/app/public/plates
mkdir -p /var/www/html/public/storage
chown -R www-data:www-data /var/www/html/storage/app/public
chmod -R 755 /var/www/html/storage/app/public

# Create storage link again to ensure it works
rm -f /var/www/html/public/storage
ln -sf /var/www/html/storage/app/public /var/www/html/public/storage
echo "✅ Storage link created for images"

# Optimize Laravel (as per README)
echo "⚡ Optimizing Laravel (README commands)..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Set permissions
echo "🔐 Setting file permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true
chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache || true

# Create a simple PHP test file
echo "🧪 Creating test files..."
cat > /var/www/html/public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>BSS Parking System - Loading</title>
</head>
<body>
    <h1>BSS Parking System</h1>
    <p>Static HTML is working! PHP Laravel should load soon...</p>
    <p><a href="/test.php">Test PHP</a></p>
    <p><a href="/phpinfo.php">PHP Info</a></p>
    <p><a href="/debug.php">Debug Laravel</a></p>
</body>
</html>
EOF

cat > /var/www/html/public/phpinfo.php << 'EOF'
<?php
phpinfo();
EOF

cat > /var/www/html/public/test.php << 'EOF'
<?php
echo "PHP is working! " . date('Y-m-d H:i:s');
echo "<br>Memory limit: " . ini_get('memory_limit');
echo "<br>Error reporting: " . error_reporting();
echo "<br>Display errors: " . ini_get('display_errors');
EOF

cat > /var/www/html/public/debug.php << 'EOF'
<?php
echo "<h2>Laravel Debug</h2>";
echo "PHP Version: " . phpversion() . "<br>";
echo "Current directory: " . __DIR__ . "<br>";
echo "Laravel path: " . dirname(__DIR__) . "<br>";

// Check if Laravel can load
try {
    require_once __DIR__ . '/../vendor/autoload.php';
    echo "✅ Composer autoload: SUCCESS<br>";
    
    $app = require_once __DIR__ . '/../bootstrap/app.php';
    echo "✅ Laravel bootstrap: SUCCESS<br>";
    
    echo "App instance: " . get_class($app) . "<br>";
    
} catch (Exception $e) {
    echo "❌ Laravel Error: " . $e->getMessage() . "<br>";
    echo "File: " . $e->getFile() . " Line: " . $e->getLine() . "<br>";
}
EOF

# Test PHP-FPM is running
echo "🔍 Testing PHP-FPM..."
php-fpm -t || echo "PHP-FPM configuration test failed"

# Make sure PHP-FPM socket is ready
echo "🔍 Checking PHP-FPM socket..."
netstat -an | grep 9000 || echo "PHP-FPM not listening on port 9000 yet"

# Test if Laravel routes work
echo "🔍 Testing Laravel..."
cd /var/www/html
php artisan route:list || echo "Laravel route listing failed"

# Ensure proper permissions for Laravel
echo "🔐 Final permission check..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;
find /var/www/html -type d -exec chmod 755 {} \;
chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Start web services
echo "🎯 Starting nginx and PHP-FPM..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 