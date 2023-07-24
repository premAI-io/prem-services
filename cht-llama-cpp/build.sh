#!/bin/bash
set -e
export VERSION=1.0.4

docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=gpt4all-lora-q4" \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 \
    .

docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=vicuna-7b-q4" \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:latest \
    --tag ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:$VERSION \
    --platform linux/arm64,linux/amd64 \
    .
docker run --rm ghcr.io/premai-io/chat-vicuna-7b-q4-cpu:$VERSION pytest
