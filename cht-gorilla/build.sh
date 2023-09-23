#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-gorilla-falcon-7b-gpu gorilla-llm/gorilla-falcon-7b-hf-v0 ${@:1}
build_gpu ghcr.io/premai-io/chat-gorilla-mpt-7b-gpu    gorilla-llm/gorilla-mpt-7b-hf-v0    ${@:1}
