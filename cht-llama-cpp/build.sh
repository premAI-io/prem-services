#!/bin/bash
set -e
export VERSION=1.0.4
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/chat-gpt4all-lora-q4-cpu gpt4all-lora-q4 ${@:1}
build_cpu ghcr.io/premai-io/chat-vicuna-7b-q4-cpu    vicuna-7b-q4    ${@:1}
