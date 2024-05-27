#!/bin/sh
set -e
apk update && apk add curl bash jq && rm -f /var/cache/apk/*

                        