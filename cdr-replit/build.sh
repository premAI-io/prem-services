#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/coder-replit-code-v1-3b-gpu replit/replit-code-v1-3b ${@:1}
