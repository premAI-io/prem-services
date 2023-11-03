#!/usr/bin/env bash
# Usage: setup-redis.sh [redis-stack-server-options]
set -eEuo pipefail

tmpdir="$HOME/.config/prem/redis-$(uuidgen 2>/dev/null || uuid)"

cleanup(){
  for i in $(jobs -p); do
    kill -n 9 $i || :
  done
  rm -rf "$tmpdir"
  exit 0
}
trap "cleanup" SIGINT SIGTERM ERR EXIT

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    arch_suffix=catalina.x86_64 ;;
  arm64|aarch64)
    arch_suffix=monterey.arm64 ;;
  *)
    echo >&2 "Unsupported architecture: $ARCH"; exit 1 ;;
esac
url="https://packages.redis.io/redis-stack/redis-stack-server-7.2.0-v6.$arch_suffix.zip"

mkdir -p "$tmpdir"
echo "Downloading Redis Stack Server for $ARCH..."
curl -fsSL "$url" > "$tmpdir/redis-stack-server.zip"
echo "Unpacking Redis Stack Server..."
unzip -d "$tmpdir" "$tmpdir/redis-stack-server.zip"
rm "$tmpdir/redis-stack-server.zip"

REDISEARCH_ARGS="MAXSEARCHRESULTS 10000 MAXAGGREGATERESULTS 10000"
MODULEDIR="$tmpdir/lib"

(PATH="$tmpdir/bin:$PATH" "$tmpdir/bin/redis-stack-server" "$@" || \
 PATH="$tmpdir/bin:$PATH" "$tmpdir/bin/redis-server" \
 "$tmpdir/etc/redis-stack.conf" \
 --dir "$tmpdir" \
 --protected-mode no \
 --daemonize no \
 --loadmodule "${MODULEDIR}/redisearch.so" ${REDISEARCH_ARGS} \
 "$@") &

wait
