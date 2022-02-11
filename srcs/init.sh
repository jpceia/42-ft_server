#!/bin/bash

# Starting services
service nginx start
service mysql start
service php7.3-fpm start

# Checking services status
nginx -t
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
