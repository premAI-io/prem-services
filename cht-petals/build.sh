#!/bin/bash
set -e
export VERSION=1.0.4
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/chat-codellama-34b-cpu   codellama-34b   ${@:1}
build_cpu ghcr.io/premai-io/chat-stable-beluga-2-cpu stable-beluga-2 ${@:1}
