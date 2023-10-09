#!/bin/bash
set -e
export VERSION=1.0.6
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/chat-mistral-7b-q5 mistral-7b-instruct-v0.1.Q5_0 --build-arg="MODEL_DOWNLOAD_URL=https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q5_0.gguf" ${@:1}
build_cpu ghcr.io/premai-io/chat-mistral-7b-q5 mistral-7b-openorca.Q5_K_S --build-arg="MODEL_DOWNLOAD_URL=https://huggingface.co/TheBloke/Mistral-7B-OpenOrca-GGUF/resolve/main/mistral-7b-openorca.Q5_K_S.gguf" ${@:1}
