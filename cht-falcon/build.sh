#!/bin/bash
set -e
export VERSION=1.0.0
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-falcon-7b-instruct-gpu tiiuae/falcon-7b-instruct ${@:1}
