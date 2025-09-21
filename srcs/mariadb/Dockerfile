FROM debian:bookworm

# Paketleri kur
RUN apt-get update && apt-get install -y \
    mariadb-server mariadb-client gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Config dosyası (opsiyonel değiştirebilirsin)
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY tools/mariadb_setup.sh /usr/local/bin/mariadb_setup.sh
RUN chmod +x /usr/local/bin/mariadb_setup.sh


EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb_setup.sh"]

CMD ["mariadbd"]
