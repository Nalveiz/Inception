#!/bin/bash
set -e

echo "Starting MariaDB setup..."

# Start MariaDB service
service mariadb start

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping --silent; do
    echo "MariaDB is starting..."
    sleep 2
done

# Setup database and user if not exists
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Setting up database and users..."
    mysql -u root <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    echo "Database setup completed!"
else
    echo "Database '${MYSQL_DATABASE}' already exists, skipping init."
fi

# Stop the service and start mysqld directly
service mariadb stop

echo "Starting MariaDB server..."
exec mysqld --user=mysql --console
