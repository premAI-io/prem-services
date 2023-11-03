#!/usr/bin/env bash
set -e
export VERSION=1.0.5

test -f venv/bin/activate || python -m venv venv
source venv/bin/activate

pip install -r requirements.txt pyinstaller
NAME=ebd-all-minilm-${VERSION}-aarch64-apple-darwin
pyinstaller --onefile \
  --copy-metadata filelock \
  --copy-metadata huggingface-hub \
  --copy-metadata numpy \
  --copy-metadata packaging \
  --copy-metadata pyyaml \
  --copy-metadata regex \
  --copy-metadata requests \
  --copy-metadata safetensors \
  --copy-metadata tokenizers \
  --copy-metadata tqdm \
  --hidden-import=pytorch \
  --collect-data torch \
  --copy-metadata torch \
  --hidden-import=tiktoken_ext.openai_public \
  --hidden-import=tiktoken_ext \
  --name=$NAME \
  --add-data 'main.py:.' \
  main.py
cp dist/$NAME dist/ebd-all-minilm-${VERSION%%.*}-aarch64-apple-darwin

deactivate
