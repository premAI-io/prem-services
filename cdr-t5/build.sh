#!/bin/bash
set -e
export VERSION=1.0.1
source "$(dirname "${BASH_SOURCE[0]}")/../utils.sh"

build_cpu ghcr.io/premai-io/coder-codet5p-220m-py-cpu Salesforce/codet5p-220m-py ${@:1}
