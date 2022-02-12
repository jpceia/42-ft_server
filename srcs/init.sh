#!/bin/bash

# Write nginx config from template
sed 's@$AUTOINDEX@'"$AUTOINDEX"'@' < /etc/nginx/conf.d/nginx.template > /etc/nginx/sites-available/ft_server.conf
ln -s /etc/nginx/sites-available/ft_server.conf /etc/nginx/sites-enabled/ # creates symbolic link

# Check nginx config file
nginx -t

# Starting services
service nginx start
service mysql start
service php7.3-fpm start

# Checking services status
service nginx status
service mysql status
service php7.3-fpm status

# ----------------------------------------------------------------------------
# CONFIGURE A WORDPRESS DATABASE
# ----------------------------------------------------------------------------

# Create Database
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password

# Grant privileges to user 'root'
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password

# Reload the grant tables
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# use auth_socker plugin for authentication, it will check the user is connectig using a UNIX socker and then compares the username
echo "update mysql.user set plugin='' where user='root';" | mysql -u root --skip-password

bash
