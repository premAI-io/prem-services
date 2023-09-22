#!/bin/bash
set -e
export VERSION=1.0.4
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-dolly-v2-12b-gpu databricks/dolly-v2-12b ${@:1}
