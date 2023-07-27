#!/bin/bash
set -e
export VERSION=1.0.0

IMAGE=ghcr.io/premai-io/coder-codet5p-220m-py-cpu
docker buildx build ${@:1} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    --platform ${BUILDX_PLATFORM:-linux/arm64,linux/amd64} \
    .
if test -z $TESTS_SKIP_CPU; then
  docker run --rm $IMAGE:$VERSION pytest
fi
