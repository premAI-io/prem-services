#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-mpt-7b-gpu     mosaicml/mpt-7b-chat     ${@:1}
build_gpu ghcr.io/premai-io/mpt-7b-gpu          mosaicml/mpt-7b          ${@:1}
build_gpu ghcr.io/premai-io/mpt-7b-instruct-gpu mosaicml/mpt-7b-instruct ${@:1}
