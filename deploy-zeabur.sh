#!/bin/bash

# Zeabur Deployment Script for BSS Parking System
echo "🚀 Starting Zeabur deployment for BSS Parking System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "composer.json" ] || [ ! -f "package.json" ]; then
    print_error "Not in a Laravel project directory!"
    exit 1
fi

print_status "Preparing for Zeabur deployment..."

# Update dependencies
print_status "Updating Composer dependencies..."
composer update --no-dev --optimize-autoloader --no-scripts --no-progress --prefer-dist

if [ $? -ne 0 ]; then
    print_error "Composer update failed!"
    exit 1
fi

print_status "Updating NPM dependencies..."
npm install --no-audit --no-fund

if [ $? -ne 0 ]; then
    print_error "NPM install failed!"
    exit 1
fi

# Build frontend assets
print_status "Building frontend assets..."
npm run production

if [ $? -ne 0 ]; then
    print_error "Frontend build failed!"
    exit 1
fi

# Clear Laravel caches
print_status "Clearing Laravel caches..."
php artisan cache:clear 2>/dev/null || true
php artisan config:clear 2>/dev/null || true
php artisan route:clear 2>/dev/null || true
php artisan view:clear 2>/dev/null || true

# Optimize for production
print_status "Optimizing for production..."
composer dump-autoload --optimize --classmap-authoritative

# Create necessary directories
print_status "Creating necessary directories..."
mkdir -p storage/logs
mkdir -p storage/framework/cache/data
mkdir -p storage/framework/sessions
mkdir -p storage/framework/views
mkdir -p bootstrap/cache

# Set proper permissions
chmod -R 755 storage
chmod -R 755 bootstrap/cache

print_status "✅ Zeabur deployment preparation complete!"
print_status "📋 Next steps:"
echo "   1. Commit and push your changes to git"
echo "   2. Deploy to Zeabur via your dashboard"
echo "   3. Your MySQL configuration is already set in the startup script:"
echo "      ✅ Host: 43.153.199.217"
echo "      ✅ Port: 32628"
echo "      ✅ Database: zeabur"
echo "      ✅ Username: root"
echo "      ✅ Password: E384qheG5ioSw6fbHZ01kDxa9uKQ2cj7"
echo "   4. Your APP_URL is configured: https://bss-parking-tride.zeabur.app"
echo "   5. Monitor the build logs in Zeabur dashboard"
echo "   6. Access your app at: https://bss-parking-tride.zeabur.app"

print_warning "All configuration is complete - ready for immediate deployment!"
print_status "🎯 Ready to deploy to Zeabur!" 