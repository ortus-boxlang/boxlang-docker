#!/bin/sh
set -e

apk update

# Update all packages to make sure security updates are applied
apk upgrade

apk add curl bash unzip jq && rm -f /var/cache/apk/*
