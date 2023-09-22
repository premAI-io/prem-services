#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/text-to-audio-bark-cpu bark/t2a-bark ${@:1}
build_gpu ghcr.io/premai-io/text-to-audio-bark-gpu bark/t2a-bark ${@:1}
