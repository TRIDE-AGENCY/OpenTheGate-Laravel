#!/bin/sh

# Start script for Laravel Docker container (CI/CD optimized)

echo "🚀 Starting Laravel application..."

# Set environment variables if not already set
export DB_HOST=${DB_HOST:-mysql}
export DB_PORT=${DB_PORT:-3306}
export DB_DATABASE=${DB_DATABASE:-db_bss_parking}
export DB_USERNAME=${DB_USERNAME:-laravel}

# Enhanced database connection check with timeout
echo "⏳ Waiting for database connection..."
TIMEOUT=120
COUNTER=0

while [ $COUNTER -lt $TIMEOUT ]; do
    # Try to connect to MySQL directly
    if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USERNAME" -p"$DB_PASSWORD" -e "SELECT 1;" "$DB_DATABASE" > /dev/null 2>&1; then
        echo "✅ Database connection successful!"
        break
    fi
    
    echo "⏳ Database not ready, waiting... ($COUNTER/$TIMEOUT)"
    sleep 3
    COUNTER=$((COUNTER + 3))
done

if [ $COUNTER -ge $TIMEOUT ]; then
    echo "❌ Database connection timeout after $TIMEOUT seconds"
    echo "🔍 Checking database connectivity..."
    echo "DB_HOST: $DB_HOST"
    echo "DB_PORT: $DB_PORT"
    echo "DB_DATABASE: $DB_DATABASE"
    echo "DB_USERNAME: $DB_USERNAME"
    
    # Try to show more debugging info
    nc -z "$DB_HOST" "$DB_PORT" && echo "✅ Port $DB_PORT is open" || echo "❌ Cannot connect to port $DB_PORT"
    exit 1
fi

# Run Laravel setup commands
echo "🔧 Setting up Laravel application..."

# Create .env file if it doesn't exist
if [ ! -f /var/www/html/.env ]; then
    echo "📝 Creating .env file..."
    cat > /var/www/html/.env << EOF
APP_NAME="BSS Parking"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=${APP_URL:-http://localhost}

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
fi

# Generate app key
echo "🔑 Generating application key..."
php artisan key:generate --force

# Create storage link
echo "🔗 Creating storage link..."
php artisan storage:link --force || true

# Run database operations with error handling
echo "🗄️ Running database migrations..."
php artisan migrate --force || {
    echo "❌ Migration failed, but continuing..."
    echo "ℹ️ Database might need manual setup"
}

# Clear and cache config for production
echo "⚡ Optimizing application..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Set proper permissions
echo "🔐 Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache || true
chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache || true

# Start supervisord to manage nginx and php-fpm
echo "🎯 Starting services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 