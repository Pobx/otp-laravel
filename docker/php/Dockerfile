FROM php:8.3-fpm-alpine

# Set build arguments
ARG UID=501
ARG GID=20

# Install system dependencies & libraries required for extensions, Thai OCR, DomPDF Thai fonts, and schema dump
RUN apk add --no-cache \
    bash \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    mysql-client \
    tesseract-ocr \
    tesseract-ocr-data-tha \
    tesseract-ocr-data-eng \
    shadow \
    tzdata

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        bcmath \
        gd \
        intl \
        zip \
        mbstring \
        exif \
        pcntl \
        opcache

# Install Redis extension via PECL
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setup non-root user matching host UID/GID
RUN groupmod -g ${GID} www-data || true \
    && usermod -u ${UID} -g ${GID} www-data || true

# Configure MySQL client (disable SSL & self-signed check for container linking)
RUN mkdir -p /etc/my.cnf.d \
    && printf '[client]\nssl=0\nskip-ssl\n[mysql]\nssl=0\nskip-ssl\n[mysqldump]\nssl=0\nskip-ssl\n' > /etc/my.cnf.d/client.cnf \
    && cp /etc/my.cnf.d/client.cnf /etc/my.cnf

WORKDIR /var/www/html

USER www-data
