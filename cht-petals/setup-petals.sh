#!/usr/bin/env bash
# Usage: setup-petals.sh [--model-path=<DIR>] [--dht-prefix=<PREFIX>] [--port=<INT>]
set -eEuo pipefail

tmpdir="${PREM_APPDIR:-.}/petals-$(uuidgen)"

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

# clone source
git clone -n --depth=1 --filter=tree:0 https://github.com/premAI-io/prem-services.git "$tmpdir"
git -C "$tmpdir" sparse-checkout set --no-cone cht-petals
git -C "$tmpdir" checkout
# install deps
"${PREM_PYTHON:-python}" -m pip install -r "$tmpdir/cht-petals/requirements.txt"
# run server
PYTHONPATH="$tmpdir/cht-petals" "${PREM_PYTHON:-python}" "$tmpdir/cht-petals/main.py" "$@" &

wait
