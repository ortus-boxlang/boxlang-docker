#!/bin/bash

# Make sure errors (like curl failing, or unzip failing, or anything failing) fails the build
set -ex
printenv;

# Validate required environment variable
if [ -z "$BOXLANG_VERSION" ]; then
    echo "Error: BOXLANG_VERSION environment variable is required"
    exit 1
fi

# Use our quick installer
cd /tmp

curl -fsSL https://install.boxlang.io | /bin/bash -s -- --without-commandbox