#!/bin/sh
set -e

apt-get update \
	&& apt-get install --assume-yes \
								apt-utils \
								ca-certificates \
								curl \
								unzip \
								jq \
								nginx \
								openssl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Create SSL directory + Nginx directories
mkdir -p /etc/nginx/ssl /var/log/nginx /var/cache/nginx
chown -R www-data:www-data /var/log/nginx /var/cache/nginx

# Generate a self-signed SSL certificate
openssl req -x509 -nodes -newkey rsa:2048 \
    -days 365 \
    -subj "/CN=localhost" \
    -keyout /etc/nginx/ssl/selfsigned.key \
    -out /etc/nginx/ssl/selfsigned.crt