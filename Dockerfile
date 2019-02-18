FROM php:5.5-apache

RUN a2enmod rewrite

# install the PHP extensions we need
RUN apt-get update -y && apt-get install -y apt-utils \
    && apt-get install -y libpng12-dev libjpeg-dev libpq-dev ssmtp

RUN rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql mysql mysqli

RUN echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/sendmail.ini

WORKDIR /var/www/html

# https://www.drupal.org/node/3060/release?api_version%5B%5D=87
ENV DRUPAL_VERSION 6.38

RUN curl -fSL "http://ftp.drupal.org/files/projects/drupal-${DRUPAL_VERSION}.tar.gz" -o drupal.tar.gz \
    && tar -xz --strip-components=1 -f drupal.tar.gz \
    && rm drupal.tar.gz \
    && chown -R www-data:www-data sites
