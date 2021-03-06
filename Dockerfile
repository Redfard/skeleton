FROM theparticles/libs:7.1

COPY ./docker/php/fpm_www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/php/docker-php-ext-imagick.ini /usr/local/etc/php/conf.d/docker-php-ext-imagick.ini
COPY ./docker/php/php.ini /usr/local/etc/php/


COPY . /app
COPY ./.env.example /app/.env

# Register the COMPOSER_HOME environment variable
ENV COMPOSER_HOME /composer
# Add global binary directory to PATH and make sure to re-export it
ENV PATH /composer/vendor/bin:$PATH
# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Setup the Composer installer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

# Install Composer
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && rm -rf /tmp/composer-setup.php

