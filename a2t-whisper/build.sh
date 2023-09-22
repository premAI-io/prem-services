#!/bin/bash
set -e
export VERSION=1.0.2
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/audio-to-text-whisper-tiny-cpu     tiny     ${@:1}
build_gpu ghcr.io/premai-io/audio-to-text-whisper-large-v2-gpu large-v2 ${@:1}
