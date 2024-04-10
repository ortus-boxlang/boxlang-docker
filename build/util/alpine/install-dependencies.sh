#!/bin/sh
apk update && apk add curl bash jq && rm -f /var/cache/apk/*
#curl jq bash openssl libgcc libstdc++ libx11 glib libxrender libxext libintl shadow fontconfig
                        