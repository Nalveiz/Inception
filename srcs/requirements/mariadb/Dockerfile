FROM debian:bookworm


# Install MariaDB server
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld /var/log/mysql \
    && chown -R mysql:mysql /var/run/mysqld /var/log/mysql \
    && chmod 755 /var/run/mysqld /var/log/mysql

# Copy configuration files
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/mariadb_setup.sh

# Expose port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]
