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
curl -fsSL https://downloads.ortussolutions.com/ortussolutions/boxlang/install-boxlang.sh -o install-boxlang.sh

chmod +x install-boxlang.sh
./install-boxlang.sh $BOXLANG_VERSION

# Clean up
rm -f install-boxlang.sh
