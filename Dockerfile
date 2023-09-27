FROM inf8n8ty/webdev:latest
#
##
#
RUN apt-get update && apt-get upgrade -y
RUN apt-get install nano zsh libcurl4-openssl-dev libzip-dev libxml2-dev -y
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN docker-php-ext-install pdo pdo_mysql curl zip bcmath calendar dom
RUN rm -f /etc/apache2/sites-available/000-default.conf
#
##      XDEBUG
#
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN touch    "/var/log/apache2/xdebug.log"
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
COPY .conf/apache2.conf "/etc/apache2/sites-available/000-default.conf"
COPY .conf/php.ini "/usr/local/etc/php/conf.d/"
RUN a2enmod rewrite
RUN mkdir -p "/home/webuser"
RUN chown -R webuser:webuser "/home/webuser"
RUN PATH="/var/www/html/node_modules/.bin:$PATH"
RUN export PATH

CMD ["apache2-foreground"]
