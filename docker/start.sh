#!/bin/sh

# Start script for Laravel Docker container

# Wait for database to be ready
echo "Waiting for database connection..."
until php artisan migrate:status > /dev/null 2>&1; do
    echo "Database not ready, waiting..."
    sleep 2
done

# Run Laravel setup commands
echo "Setting up Laravel application..."

# Generate app key if not exists
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
    php artisan key:generate --force
fi

# Create storage link
php artisan storage:link --force

# Clear and cache config for production
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run database migrations
php artisan migrate --force

# Set proper permissions
chown -R www-data:www-data /var/www/html/storage
chown -R www-data:www-data /var/www/html/bootstrap/cache
chmod -R 755 /var/www/html/storage
chmod -R 755 /var/www/html/bootstrap/cache

# Start supervisord to manage nginx and php-fpm
echo "Starting services..."
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf 