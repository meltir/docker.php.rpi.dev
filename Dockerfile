# php-fpm-composer-memcache-xdebug:alpine
# php-fpm-symfony:alpine

FROM php:7.2.10-fpm-alpine

VOLUME /var/www/

RUN set -xs \
	&& apk update \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& apk add --no-cache --virtual .build-deps zlib-dev libmemcached-dev \
	&& apk add --no-cache zlib libmemcached \
	&& printf "\n" | pecl install memcached \
	&& docker-php-ext-enable memcached \
	&& apk del .phpize-deps \
	&& apk del .build-deps \
	&& echo "session.save_handler = memcached" >>  /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini \
	&& echo "session.save_path = \"memcached:11211\"" >>  /usr/local/etc/php/conf.d/docker-php-ext-memcached.ini
	
	
RUN set -xs \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	&& apk del .phpize-deps

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/
	
RUN set -xs \
	&& apk add --no-cache zlib-dev icu-dev icu \
	&& docker-php-ext-install pdo pdo_mysql zip intl \
	&& apk del zlib-dev icu-dev

RUN docker-php-ext-enable opcache


RUN set -xs \
    && apk add --no-cache git

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#RUN set -xs \
#	&& composer create-project symfony/symfony-demo app \
#	&& cd app \
#	&& ./bin/phpunit
	
#RUN set -xs \
#	&& composer require symfony/requirements-checker

WORKDIR /var/www/app
	
EXPOSE 9001
