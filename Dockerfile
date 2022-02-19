FROM docker-registry:5000/mhofmair/webdev_php
#
##
#
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nano zsh libcurl4-openssl-dev libzip-dev libxml2-dev -y
RUN docker-php-ext-install pdo pdo_mysql curl zip bcmath calendar dom
#
## INSTALL Xdebug
#
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
RUN rm -f /etc/apache2/sites-available/000-default.conf
COPY .conf/apache2.conf "/etc/apache2/sites-available/000-default.conf"
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
RUN a2enmod rewrite
RUN mkdir -p "/home/webuser"
RUN chown -R webuser:webuser "/home/webuser"
CMD ["apache2-foreground"]