#!/bin/sh
set -e

apt-get update \
	&& apt-get install --assume-yes \
                                apt-utils \
                                ca-certificates \
                                curl \
                                unzip \
                                jq \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*