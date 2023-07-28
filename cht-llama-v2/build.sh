#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-llama-2-7b-gpu       llama-2-7b-hf       ${@:1}
build_gpu ghcr.io/premai-io/chat-llama-2-7b-chat-gpu  llama-2-7b-chat-hf  ${@:1}
build_gpu ghcr.io/premai-io/chat-llama-2-13b-gpu      llama-2-13b-hf      ${@:1}
build_gpu ghcr.io/premai-io/chat-llama-2-13b-chat-gpu llama-2-13b-chat-hf ${@:1}
