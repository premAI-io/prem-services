#!/bin/bash
set -e
export VERSION=1.0.3

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=runwayml/stable-diffusion-v1-5" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-xl-gpu
docker buildx build --push \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-xl-base-1.0" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-xl-with-refiner-gpu
docker buildx build --push \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-xl-base-1.0" \
    --build-arg="REFINER_ID=stabilityai/stable-diffusion-xl-refiner-1.0" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-x4-upscaler" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi

IMAGE=ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/sd-x2-latent-upscaler" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .
if test -z $TESTS_SKIP_GPU; then
  docker run --rm --gpus all $IMAGE:$VERSION pytest
fi
