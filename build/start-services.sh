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

# Check if the NGINX process started successfully
if ! kill -0 $NGINX_PID 2>/dev/null; then
	echo "Failed to start nginx."
	exit 1
else
	echo "NGINX started with PID $NGINX_PID."
fi

# Start BoxLang in the foreground
echo "Starting BoxLang application..."
exec $BUILD_DIR/run.sh