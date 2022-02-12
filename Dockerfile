FROM debian:buster

ENV AUTOINDEX=on

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /var/www/html/

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget		# for downloads
# RUN apt-get -y install gettext-base	# for envsubst

# Install nginx
RUN apt-get -y install nginx

# Removing defaults
RUN rm -f index.nginx-debian.html
RUN rm -f /etc/nginx/sites-enabled/default

# Install MariaDB
RUN apt-get -y install mariadb-server

# Install PHP My Admin
RUN apt-get -y install \
	php7.3 \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd \
	php-cli \
	php-mbstring

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin

# Install Wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

# SSL Certificate Setting
# https://stackoverflow.com/questions/68948910/make-a-certificate-for-testing-purposes-but-not-self-signed
RUN openssl req -x509 -nodes -days 365 -subj "/C=PT/ST=Portugal/L=Lisbon/O=42School/OU=42Lisboa/CN=jceia" \
	-newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

# Change authorization
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

# Copying config files
COPY ./srcs/config.inc.php phpmyadmin
COPY ./srcs/wp-config.php .
COPY ./srcs/nginx.template /etc/nginx/conf.d/
COPY ./srcs/autoindex /usr/bin/
RUN chmod 755 /usr/bin/autoindex

# init script and launch bash
COPY ./srcs/init.sh ./

CMD bash init.sh
