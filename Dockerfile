# Multi-stage build for Laravel application
FROM node:18-alpine AS node-builder

WORKDIR /app
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# PHP Production Stage
FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libzip-dev \
    nginx \
    supervisor \
    mysql-client \
    netcat-openbsd

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create app directory
WORKDIR /var/www/html

# Copy composer files
COPY composer.json composer.lock ./

# Install composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy application code
COPY . .

# Copy built assets from node-builder stage
COPY --from=node-builder /app/public/build ./public/build

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Copy configuration files
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create necessary directories
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /var/run \
    && mkdir -p /var/www/html/storage/app/public

# Generate optimized autoloader
RUN composer dump-autoload --optimize

# Create startup scripts
COPY docker/start.sh /start.sh
COPY docker/start-zeabur.sh /start-zeabur.sh
RUN chmod +x /start.sh /start-zeabur.sh

EXPOSE 80

# Use Zeabur-optimized startup script
CMD ["/start-zeabur.sh"]

# Add environment variables
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysql.zeabur.internal
ENV DB_PORT=3306
ENV DB_DATABASE=db_bss_parking
ENV DB_USERNAME=root
ENV DB_PASSWORD=8c1Dk5ifwQmvF90s4oNV67tOIpYd3rR2 