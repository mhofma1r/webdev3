FROM php:8.1-apache
# Update and install packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y nano zsh libcurl4-openssl-dev libzip-dev libxml2-dev

# Install PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync
RUN install-php-extensions pdo pdo_mysql curl zip bcmath calendar dom

# XDEBUG
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN touch "/var/log/apache2/xdebug.log"
COPY .conf/90-xdebug.ini "/usr/local/etc/php/conf.d/"
COPY .conf/apache2.conf "/etc/apache2/sites-available/000-default.conf"
COPY .conf/php.ini "/usr/local/etc/php/conf.d/"
COPY .conf/envvars "/etc/apache2/"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Set up user and permissions
RUN mkdir -p "/home/webuser"
RUN groupadd -r webuser --gid=1000
RUN useradd -r -g webuser --uid=1000 -d "/home/webuser" webuser
RUN chown -R webuser:webuser "/home/webuser"

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"&& \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"&& \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"


# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_21.x | bash -
RUN apt-get install -y nodejs

# Set PATH
RUN PATH="/var/www/html/node_modules/.bin:$PATH"
RUN export PATH

CMD ["apache2-foreground"]
