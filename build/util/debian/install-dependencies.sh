#!/bin/sh
set -e

apt-get update

# Upgrade all packages to make sure security patches are applied
apt-get -y upgrade

apt-get autoremove -y

apt-get install --assume-yes \
                                apt-utils \
                                ca-certificates \
                                curl \
                                unzip \
                                jq \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*