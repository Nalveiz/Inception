FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/create_ssl.sh /usr/local/bin/


RUN chmod +x /usr/local/bin/create_ssl.sh

RUN /usr/local/bin/create_ssl.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
