#!/bin/sh

DB_NAME=testdb
MYSQL_USER=user
SQL_PASSWORD=123
SQL_ROOT_PASSWD=123

mysql_install_db

# /etc/init.d/mysql start
service mariadb start

if [ -d "/var/lib/mysql/$DB_NAME" ]; then
    echo "Database exists alrdy"
else
    mysql_secure_installation << _EOF_
Y
rootabc
rootabc
Y
n
Y
Y
_EOF_

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$SQL_ROOT_PASSWD' ;FLUSH PRIVILEGES;" | mariadb -uroot

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME; GRANT ALL ON $DB_NAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD'; FLUSH PRIVILEGES;" | mariadb -u root

# mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

fi

mariadb-admin shutdown

sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/"    /etc/mysql/mariadb.conf.d/50-server.cnf

mariadbd
# sleep infinity
# mysqld_safe

