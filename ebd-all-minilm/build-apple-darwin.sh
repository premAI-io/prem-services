#!/usr/bin/env bash

# Usage: ./build-apple-darwin.sh <arch> <arch_name>
#
# Parameters:
#   arch: The architecture to use.
#   arch_name: The architecture name to use.

set -e

ARCH=${1:-arm64}
ARCH_NAME=${2:-aarch64}

export VERSION=1.0.5

test -f venv/bin/activate || python -m venv venv
source venv/bin/activate


pip install -r requirements.txt pyinstaller
NAME=ebd-all-minilm-${VERSION}-x86_64-apple-darwin
pyinstaller --onefile \
  --copy-metadata tqdm \
  --copy-metadata regex \
  --copy-metadata requests \
  --copy-metadata packaging \
  --copy-metadata filelock \
  --copy-metadata numpy \
  --copy-metadata huggingface-hub \
  --copy-metadata safetensors \
  --copy-metadata pyyaml \
  --hidden-import=pytorch \
  --collect-data torch \
  --copy-metadata torch \
  --add-data 'main.py:.' \
  --copy-metadata tokenizers \
  --hidden-import=tiktoken_ext.openai_public \
  --hidden-import=tiktoken_ext \
  --target-arch $ARCH \
  --name=$NAME \
  main.py
cp dist/$NAME dist/ebd-all-minilm-${VERSION%%.*}-$ARCH_NAME-apple-darwin

deactivate
