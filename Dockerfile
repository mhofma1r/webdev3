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
RUN pecl install xdebug
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
#RUN docker-php-ext-enable xdebug
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug ssh2
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
RUN rm -f /etc/apache2/sites-available/000-default.conf
COPY .conf/apache2.conf "/etc/apache2/sites-available/000-default.conf"
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
COPY .conf/php.ini "/usr/local/etc/php/conf.d/"
RUN a2enmod rewrite
RUN mkdir -p "/home/webuser"
RUN chown -R webuser:webuser "/home/webuser"
RUN touch "/var/log/xdebug.log"
CMD ["apache2-foreground"]