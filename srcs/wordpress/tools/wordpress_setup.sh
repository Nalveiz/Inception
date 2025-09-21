#!/bin/bash

echo "Starting WordPress setup..."

# Wait for database to be ready
echo "Waiting for database connection..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
    sleep 1
done
echo "Database is ready!"

# Download WordPress
echo "Downloading WordPress..."
if [ ! -f /var/www/html/wp-config.php ]; then
    cd /var/www/html
    
    # Download WordPress core files
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    
    # Download WP-CLI with a more reliable method
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    # Create wp-config.php
    echo "Creating wp-config.php..."
    wp config create --dbname="$WORDPRESS_DB_NAME" \
                     --dbuser="$WORDPRESS_DB_USER" \
                     --dbpass="$WORDPRESS_DB_PASSWORD" \
                     --dbhost="$WORDPRESS_DB_HOST" \
                     --allow-root
    
    # Install WordPress
    echo "Installing WordPress..."
    wp core install --url="$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --allow-root
    
    # Create additional user
    echo "Creating additional user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
                   --user_pass="$WP_USER_PASSWORD" \
                   --role=editor \
                   --allow-root
    
    echo "WordPress installation completed!"
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F