#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_gpu ghcr.io/premai-io/chat-xgen-7b-8k-inst-gpu Salesforce/xgen-7b-8k-inst ${@:1}
