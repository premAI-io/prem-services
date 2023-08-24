#!/bin/bash
set -e
export VERSION=1.0.3
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/embeddings-all-minilm-l6-v2-cpu all-MiniLM-L6-v2 ${@:1}
build_gpu ghcr.io/premai-io/embeddings-all-minilm-l6-v2-gpu all-MiniLM-L6-v2 ${@:1}
