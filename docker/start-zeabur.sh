#!/bin/sh

# Zeabur-optimized startup script for Laravel

echo "🚀 Starting BSS Parking System on Zeabur..."

# Set environment variables with Zeabur MySQL configuration
export DB_HOST="43.153.199.217"
export DB_PORT="32628"
export DB_DATABASE="zeabur"
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

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link --force || true

# Test database connection
echo "⏳ Testing database connection..."
DATABASE_READY=false

# Try connection with different methods
for attempt in 1 2 3 4 5; do
    echo "Attempt $attempt/5..."
    
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
    
    echo "⏳ Connection failed, waiting 5 seconds..."
    sleep 5
done

# Import database if connected and empty
if [ "$DATABASE_READY" = true ]; then
    echo "🗄️ Checking database tables..."
    
    # Check if tables exist
    TABLE_COUNT=$(MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$DB_DATABASE';" "$DB_DATABASE" 2>/dev/null | tail -1)
    
    if [ "$TABLE_COUNT" = "0" ] || [ -z "$TABLE_COUNT" ]; then
        echo "📥 Database is empty, importing schema..."
        if [ -f "/var/www/html/db_bss_parking.sql" ]; then
            # First create the database schema, then import
            MYSQL_PWD="$DB_PASSWORD" mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USERNAME" "$DB_DATABASE" < /var/www/html/db_bss_parking.sql
            if [ $? -eq 0 ]; then
                echo "✅ Database schema imported successfully!"
            else
                echo "⚠️ Database import failed, running migrations..."
                php artisan migrate --force || echo "Migration also failed"
            fi
        else
            echo "⚠️ SQL file not found, running migrations..."
            php artisan migrate --force || echo "Migration failed"
        fi
    else
        echo "✅ Database tables already exist ($TABLE_COUNT tables)"
        php artisan migrate --force || echo "Migration check failed"
    fi
else
    echo "⚠️ Database not ready, but starting web server anyway..."
    echo "You may need to set up the database manually later."
fi

# Optimize Laravel
echo "⚡ Optimizing Laravel..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Set permissions
echo "🔐 Setting file permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true
chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache || true

# Start web services
echo "🎯 Starting nginx and PHP-FPM..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 