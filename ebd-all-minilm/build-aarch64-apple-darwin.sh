#!/bin/bash

set -e

export VERSION=1.0.5

test -f venv/bin/activate || python -m venv venv
source venv/bin/activate


pip install -r requirements.txt pyinstaller
NAME=ebd-all-minilm-${VERSION}-aarch64-apple-darwin
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
  --target-arch arm64 \
  --name=$NAME \
  main.py
cp dist/$NAME dist/ebd-all-minilm-${VERSION%%.*}-aarch64-apple-darwin

deactivate
