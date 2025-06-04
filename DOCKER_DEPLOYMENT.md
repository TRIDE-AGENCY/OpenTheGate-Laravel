# Docker Deployment Guide for BSS Parking System

## Quick Start

1. **Make deployment script executable:**
   ```bash
   chmod +x deploy.sh
   ```

2. **Run deployment script:**
   ```bash
   ./deploy.sh
   ```

3. **Access your application:**
   - **Main App**: http://your-server-ip
   - **phpMyAdmin**: http://your-server-ip:8080

## Manual Deployment

If you prefer manual deployment:

```bash
# 1. Create environment file
cp .env.example .env
nano .env  # Edit database settings

# 2. Start services
docker-compose up -d --build

# 3. Check status
docker-compose ps
```

## Database Setup

Your `db_bss_parking.sql` file will be automatically imported when the MySQL container starts for the first time. This includes:

- All database tables
- Sample data
- User accounts
- Parking rates
- Vehicle types

## Useful Commands

```bash
# View logs
docker-compose logs -f app

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Remove everything (including data)
docker-compose down -v

# Update application
git pull && docker-compose up -d --build app
```

## Production Recommendations

1. **Change default passwords** in `docker-compose.yml`
2. **Set up SSL** with nginx reverse proxy
3. **Configure firewall** to restrict access
4. **Set up regular backups**
5. **Monitor resource usage**

## Troubleshooting

- **Database connection issues**: Check if MySQL container is healthy
- **Permission errors**: Run `docker-compose exec app chown -R www-data:www-data /var/www/html/storage`
- **App key missing**: Run `docker-compose exec app php artisan key:generate --force`

## Architecture

- **app**: Laravel application with nginx + PHP-FPM
- **mysql**: MySQL 8.0 database with auto-imported data
- **phpmyadmin**: Web-based database management

The system is ready for production use with automatic license plate detection using YOLOv11n and EasyOCR. 