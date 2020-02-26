# php-fpm-composer-memcache-xdebug:alpine
# php-fpm-symfony:alpine

FROM php:7.4.2-fpm-alpine

VOLUME /var/www/

RUN set -x \
	&& apk update \
	&& apk add --no-cache libsodium libzip icu libxslt libxml2 libpng freetype libjpeg-turbo zlib\
	&& apk add --no-cache --virtual .ext-deps libsodium-dev libzip-dev icu-dev libxslt-dev libxml2-dev freetype-dev libpng-dev libjpeg-turbo-dev zlib-dev \
	&& docker-php-ext-install pdo pdo_mysql zip intl xsl soap sockets bcmath sodium \
	&& docker-php-ext-configure gd --with-jpeg --with-freetype \
	&& docker-php-ext-install gd \
	&& apk del .ext-deps

RUN docker-php-ext-enable opcache

RUN set -x \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& apk add --no-cache --virtual .build-deps libmemcached-dev zlib-dev \
	&& apk add --no-cache libmemcached \
	&& printf "\n" | pecl install memcached \
	&& docker-php-ext-enable memcached \
	&& apk del .phpize-deps \
	&& apk del .build-deps


### DEV
# remove below packages in production image

RUN set -x \
	&& apk add --no-cache --virtual .phpize-deps autoconf dpkg-dev dpkg file g++ gcc libc-dev make pkgconf re2c \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	&& apk del .phpize-deps

COPY docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/

RUN set -x \
    && apk add --no-cache git vim

RUN curl -sSL https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sSL http://www.phpdoc.org/phpDocumentor.phar -o /usr/local/bin/phpDocumentor.phar \
    && chmod 755 /usr/local/bin/phpDocumentor.phar

RUN composer global require infection/infection friendsofphp/php-cs-fixer \
    php-cs-fixer/phpunit-constraint-isidenticalstring php-cs-fixer/phpunit-constraint-xmlmatchesxsd \
    phpstan/phpstan phpstan/phpstan-symfony phpstan/phpstan-doctrine \
    behat/behat

COPY composer_bin_path.sh /etc/profile.d/

ENV ENV=/etc/profile

### END DEV

WORKDIR /var/www

EXPOSE 9001
