#!/usr/bin/env bash
# Usage: setup-redis.sh
set -eEuo pipefail

tmpdir="${PREM_APPDIR:-.}/redis-$(uuidgen)"

cleanup(){
  for i in $(jobs -p); do
    kill -n 9 $i || :
  done
  rm -rf "$tmpdir"
  exit 0
}

trap "cleanup" SIGTERM
trap "cleanup" SIGINT
trap "cleanup" ERR

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    arch_suffix=catalina.x86_64 ;;
  arm64|aarch64)
    arch_suffix=monterey.arm64 ;;
  *)
    echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac
url="https://packages.redis.io/redis-stack/redis-stack-server-7.2.0-v6.$arch_suffix.zip"

mkdir -p "$tmpdir"
curl -fsSL "$url" > "$tmpdir/redis-stack-server.zip"
unzip -d "$tmpdir" "$tmpdir/redis-stack-server.zip"

PATH="$tmpdir/bin:$PATH" "$tmpdir/bin/redis-stack-server" &

wait
