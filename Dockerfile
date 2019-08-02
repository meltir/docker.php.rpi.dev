# php-fpm-composer-memcache-xdebug:alpine
# php-fpm-symfony:alpine

FROM php:7.3.6-fpm-alpine

VOLUME /var/www/

RUN set -xs \
	&& apk update \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& apk add --no-cache --virtual .build-deps zlib-dev libmemcached-dev \
	&& apk add --no-cache zlib libmemcached \
	&& printf "\n" | pecl install memcached \
	&& docker-php-ext-enable memcached \
	&& apk del .phpize-deps \
	&& apk del .build-deps

	
RUN set -xs \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	&& apk del .phpize-deps

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/
	
RUN set -xs \
	&& apk add --no-cache libzip-dev libzip icu-dev icu \
	&& docker-php-ext-install pdo pdo_mysql zip intl \
	&& apk del libzip-dev icu-dev

RUN docker-php-ext-enable opcache

RUN set -xs \
    && apk add --no-cache git

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer global require infection/infection friendsofphp/php-cs-fixer

COPY composer_bin_path.sh /etc/profile.d/

ENV ENV=/etc/profile

WORKDIR /var/www
	
EXPOSE 9001
