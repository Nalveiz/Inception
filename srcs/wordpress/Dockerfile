FROM debian:bookworm

# Install PHP-FPM, PHP extensions, and other dependencies
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-soap \
    php8.2-intl \
    php8.2-zip \
    php8.2-cli \
    curl \
    wget \
    unzip \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/' /etc/php/8.2/fpm/pool.d/www.conf

# Create PHP-FPM run directory
RUN mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

# Download and install WP-CLI
RUN curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy setup script
COPY tools/wordpress_setup.sh /usr/local/bin/wordpress_setup.sh
RUN chmod +x /usr/local/bin/wordpress_setup.sh

# Create WordPress directory
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Set working directory
WORKDIR /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/wordpress_setup.sh"]
