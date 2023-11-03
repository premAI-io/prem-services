#!/usr/bin/env bash
# Usage: setup-redis.sh [redis-stack-server-options]

# Set strict error handling
set -euo pipefail

# Define the Redis directory in the home directory
REDIS_DIR="$HOME/redis-stack-server"

# Function to clean up on exit or error
cleanup() {
    echo "Cleaning up..."
    rm -rf "$REDIS_DIR"
}

# Set traps to clean up on SIGINT, SIGTERM, or script exit
trap cleanup SIGINT SIGTERM ERR EXIT

# Create the Redis directory
mkdir -p "$REDIS_DIR"

# Detect architecture for correct Redis stack server version
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)
        ARCH_SUFFIX="catalina.x86_64" ;;
    arm64 | aarch64)
        ARCH_SUFFIX="monterey.arm64" ;;
    *)
        echo "Unsupported architecture: $ARCH" >&2
        exit 1 ;;
esac

# Download the Redis Stack Server zip file for the detected architecture
REDIS_STACK_URL="https://packages.redis.io/redis-stack/redis-stack-server-7.2.0-v6.$ARCH_SUFFIX.zip"
echo "Downloading Redis Stack Server for $ARCH..."
curl -fsSL "$REDIS_STACK_URL" -o "$REDIS_DIR/redis-stack-server.zip"

# Unpack the Redis Stack Server and remove the zip file
echo "Unpacking Redis Stack Server..."
unzip "$REDIS_DIR/redis-stack-server.zip" -d "$REDIS_DIR" && rm "$REDIS_DIR/redis-stack-server.zip"

# Export PATH to include the Redis bin directory
export PATH="$REDIS_DIR/bin:$PATH"

# Run Redis Stack Server in the background
echo "Starting Redis Stack Server..."
redis-stack-server "$@" &

# Wait for all background jobs to finish
wait $!
