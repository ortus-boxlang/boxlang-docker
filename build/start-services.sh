#!/bin/bash

set -e

# Function to handle shutdown
shutdown() {
    echo "Shutting down services..."
    kill -TERM $NGINX_PID 2>/dev/null
    wait $NGINX_PID 2>/dev/null
    exit 0
}

# Trap termination signals
trap shutdown SIGTERM SIGINT

# Start NGINX in the background
echo "Starting nginx..."
nginx &
NGINX_PID=$!

# Wait briefly for NGINX to settle
sleep 2

# Start BoxLang in the foreground
echo "Starting BoxLang application..."
exec $BUILD_DIR/run.sh