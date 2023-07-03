#!/bin/bash

set -e

export VERSION=1.0.0

docker buildx build \
    --cache-from ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu:latest \
    --file ./cht-xgen/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=Salesforce/xgen-7b-8k-inst" \
    --tag ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu:latest \
    --tag ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu:$VERSION \
    ./cht-xgen
docker run --gpus all ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu:latest pytest
