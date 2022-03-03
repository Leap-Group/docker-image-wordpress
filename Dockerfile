FROM wordpress:latest

# install and configure XDebug
RUN yes | pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && mv /usr/local/etc/php/php.ini-development php.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.profiler_output_name=cachegrind.out.%t" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN apt-get update \
    && apt-get install sudo -y \
    && apt-get install vim -y  \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && sudo mv wp-cli.phar /usr/local/bin/wp
