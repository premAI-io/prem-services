#!/bin/bash

set -e

export VERSION=1.0.3

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=runwayml/stable-diffusion-v1-5" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-2" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-xl-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-xl-base-1.0" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-xl-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-xl-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/diffuser-stable-diffusion-xl-with-refiner-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-xl-base-1.0" \
    --build-arg="REFINER_ID=stabilityai/stable-diffusion-xl-refiner-1.0" \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-xl-with-refiner-gpu:latest \
    --tag ghcr.io/premai-io/diffuser-stable-diffusion-xl-with-refiner-gpu:$VERSION \
    ./dfs-diffusers

# docker system prune --all --force --volumes

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/stable-diffusion-x4-upscaler" \
    --tag ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu:latest \
    --tag ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu:$VERSION \
    ./dfs-diffusers

docker buildx build --push \
    --cache-from=ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu:latest \
    --file ./dfs-diffusers/docker/gpu/Dockerfile \
    --build-arg="MODEL_ID=stabilityai/sd-x2-latent-upscaler" \
    --tag ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu:latest \
    --tag ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu:$VERSION \
    ./dfs-diffusers

# docker run --rm --gpus all ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu:$VERSION pytest
