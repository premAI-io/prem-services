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

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=runwayml/stable-diffusion-v1-5" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .

IMAGE=ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .

# docker system prune --all --force --volumes

IMAGE=ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-x4-upscaler" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .

IMAGE=ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu
docker buildx build ${@:1} \
    --file ./docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/sd-x2-latent-upscaler" \
    --tag $IMAGE:latest \
    --tag $IMAGE:$VERSION \
    .

# docker run --rm --gpus all ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:$VERSION pytest
