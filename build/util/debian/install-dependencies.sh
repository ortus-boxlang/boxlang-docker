#!/bin/sh
set -e

apt-get update && apt-get install --assume-yes \
                                apt-utils \
                                ca-certificates \
                                curl \
                                jq