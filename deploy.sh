#!/bin/bash

# BSS Parking System - Quick Deployment Script

echo "🚀 Starting BSS Parking System deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating environment configuration..."
    cat > .env << EOF
APP_NAME="BSS Parking"
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_DEPRECATIONS_CHANNEL=null
LOG_LEVEL=debug

DB_CONNECTION=mysql
DB_HOST=mysql
DB_PORT=3306
DB_DATABASE=db_bss_parking
DB_USERNAME=laravel
DB_PASSWORD=laravel_secure_password_$(date +%s)

BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=file
SESSION_LIFETIME=120

MEMCACHED_HOST=127.0.0.1

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="\${APP_NAME}"
EOF
    echo "✅ Environment file created"
else
    echo "✅ Environment file already exists"
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start services
echo "🔨 Building and starting services..."
docker-compose up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "🎉 Deployment completed!"
echo ""
echo "🌐 Your application is available at:"
echo "   - Main App: http://localhost or http://your-server-ip"
echo "   - phpMyAdmin: http://localhost:8080 or http://your-server-ip:8080"
echo ""
echo "📊 Database credentials:"
echo "   - Host: localhost:3306"
echo "   - Database: db_bss_parking"
echo "   - Username: laravel"
echo "   - Password: (check your .env file)"
echo ""
echo "🔧 Useful commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop services: docker-compose down"
echo "   - Restart services: docker-compose restart"
echo ""
echo "📚 Check DEPLOYMENT.md for detailed configuration options" 