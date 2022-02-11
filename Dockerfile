FROM debian:buster

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget

# Install nginx
RUN apt-get -y install nginx
COPY ./srcs/default /etc/nginx/siles-available

# Install MariaDB
RUN apt-get -y install mariadb-server

# Install PHP My Admin
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

WORKDIR /var/www/html/

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin

COPY ./srcs/config.inc.php phpmyadmin

# Install Wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

COPY ./srcs/wp-config.php /var/www/html

# SSL Certificate Setting
RUN openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=Portugal/L=Lisbon/O=42/OU=42Lisboa/CN=jceia" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

# Change authorization and init bash
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

COPY ./srcs/init.sh ./

CMD bash init.sh
