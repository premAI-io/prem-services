#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest \
    --file ./cht-llama-cpp/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=gpt4all-lora-q4" \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./cht-llama-cpp

docker buildx build --push \
    --cache-from ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest \
    --file ./cht-llama-cpp/docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=vicuna-7b-q4" \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 ./cht-llama-cpp

docker run --rm ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:$VERSION pytest
