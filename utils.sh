#!/usr/bin/env bash
# common utilities used in ./*-*/build.sh
# usage:
#   build_[cg]pu <IMAGE_TAG> <MODEL_ID> [<buildx flags>...]
# env:
#   required: VERSION
#   optional: BUILDX_PLATFORM (on CPU), TESTS_SKIP_[CG]PU

build_cpu(){
  IMAGE=$1; MODEL_ID=$2
  docker buildx build ${@:3} \
    --file ./docker/cpu/Dockerfile \
    --build-arg="MODEL_ID=$MODEL_ID" \
    --label="org.opencontainers.image.source=https://github.com/premAI-io/prem-services" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    --platform ${BUILDX_PLATFORM:-linux/arm64,linux/amd64} \
    .
  if test -z $TESTS_SKIP_CPU; then docker run --rm $IMAGE:$VERSION pytest; fi
}

build_gpu(){
  IMAGE=$1; MODEL_ID=$2
  docker buildx build ${@:3} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=$MODEL_ID" \
    --label="org.opencontainers.image.source=https://github.com/premAI-io/prem-services" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
  if test -z $TESTS_SKIP_GPU; then docker run --rm --gpus all $IMAGE:$VERSION pytest; fi
}
