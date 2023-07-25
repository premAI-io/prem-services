#!/bin/bash
set -e
export VERSION=1.0.0

IMAGE=ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=Salesforce/xgen-7b-8k-inst" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi
