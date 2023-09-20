#!/bin/bash
set -e
export VERSION=1.0.0
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

# TODO: support linux/amd64
BUILDX_PLATFORM=linux/arm64 TESTS_SKIP_CPU=1 \
build_cpu ghcr.io/premai-io/chat-stable-beluga-2-cpu petals-team/StableBeluga2           ${@:1}
BUILDX_PLATFORM=linux/arm64 TESTS_SKIP_CPU=1 \
build_cpu ghcr.io/premai-io/chat-codellama-34b-cpu   premai-io/CodeLlama-34b-Instruct-hf ${@:1}
