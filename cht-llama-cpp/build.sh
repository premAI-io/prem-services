#!/bin/bash
set -e
export VERSION=1.2.0
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/chat-mistral-7b-instruct-q5 mistral-7b-instruct-v0.1.Q5_0 --build-arg="MODEL_ID=mistral-7b-instruct-v0.1.Q5_0" --build-arg="MODEL_DOWNLOAD_URL=https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q5_0.gguf" ${@:1}
build_cpu ghcr.io/premai-io/chat-mistral-7b-openorca-q5 mistral-7b-openorca.Q5_K_S    --build-arg="MODEL_ID=mistral-7b-openorca.Q5_K_S"    --build-arg="MODEL_DOWNLOAD_URL=https://huggingface.co/TheBloke/Mistral-7B-OpenOrca-GGUF/resolve/main/mistral-7b-openorca.Q5_K_S.gguf"         ${@:1}
build_cpu ghcr.io/premai-io/chat-mistral-7b-yarn-q4 yarn-mistral-7b-128k.Q4_K_M    --build-arg="MODEL_ID=yarn-mistral-7b-128k.Q4_K_M"    --build-arg="MODEL_DOWNLOAD_URL=https://huggingface.co/TheBloke/Yarn-Mistral-7B-128k-GGUF/blob/main/yarn-mistral-7b-128k.Q3_K_M.gguf"         ${@:1}
