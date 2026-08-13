FROM dunglas/frankenphp:1-php8.4

WORKDIR /app

ENV SERVER_NAME=:80
ENV APP_ENV=dev
ENV APP_DEBUG=1
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install system packages
RUN apt-get update && apt-get install -y \
    git unzip libicu-dev libzip-dev libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN install-php-extensions \
    pdo_mysql \
    intl \
    zip \
    opcache \
    gd \
    redis \
    dom \
    xml

RUN git config --global --add safe.directory /app

RUN ln -snf /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo "Europe/Berlin" > /etc/timezone

RUN apt-get update && apt-get install -y tzdata
ENV TZ=Europe/Berlin


COPY ./docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

COPY --link \
    --from=ghcr.io/symfony-cli/symfony-cli:latest \
    /usr/local/bin/symfony /usr/local/bin/symfony

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN mkdir -p /data /config \
    && chown -R 1000:1000 /data /config
