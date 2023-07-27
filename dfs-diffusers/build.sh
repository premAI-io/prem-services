#!/bin/bash
set -e
export VERSION=1.0.3
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/diffuser-stable-diffusion-2-1-gpu             stabilityai/stable-diffusion-2-1         ${@:1}
build_gpu ghcr.io/premai-io/diffuser-stable-diffusion-1-5-gpu             runwayml/stable-diffusion-v1-5           ${@:1}
build_gpu ghcr.io/premai-io/diffuser-stable-diffusion-2-gpu               stabilityai/stable-diffusion-2           ${@:1}
build_gpu ghcr.io/premai-io/diffuser-stable-diffusion-xl-gpu              stabilityai/stable-diffusion-xl-base-1.0 ${@:1}
build_gpu ghcr.io/premai-io/diffuser-stable-diffusion-xl-with-refiner-gpu stabilityai/stable-diffusion-xl-base-1.0 ${@:1} \
  --build-arg="REFINER_ID=stabilityai/stable-diffusion-xl-refiner-1.0"
build_gpu ghcr.io/premai-io/upscaler-stable-diffusion-x4-gpu              stabilityai/stable-diffusion-x4-upscaler ${@:1}
build_gpu ghcr.io/premai-io/upscaler-stable-diffusion-x2-latent-gpu       stabilityai/sd-x2-latent-upscaler        ${@:1}
