#!/bin/bash
set -e

# SSL klasörü yoksa oluştur
mkdir -p /etc/nginx/ssl

# Eğer sertifikalar zaten varsa tekrar üretme
if [ ! -f /etc/nginx/ssl/nginx.crt ] || [ ! -f /etc/nginx/ssl/nginx.key ]; then
    echo "[nginx] Generating self-signed SSL certificate..."

    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=TR/ST=Istanbul/L=Istanbul/O=42Istanbul/CN=${DOMAIN_NAME:-localhost}"

	echo "[nginx] SSL certificate created at /etc/nginx/ssl/"
else
    echo "[nginx] SSL certificate already exists, skipping."
fi

