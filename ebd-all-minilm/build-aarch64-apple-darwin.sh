#!/bin/bash
set -e

export VERSION=1.0.5

test -f venv/bin/activate || python -m venv venv
source venv/bin/activate


pip install -r requirements.txt pyinstaller
NAME=ebd-all-minilm-${VERSION}-aarch64-apple-darwin
pyinstaller --onefile \
  --target-arch arm64 \
  --name=$NAME \
  main.py
cp dist/$NAME dist/ebd-all-minilm-${VERSION%%.*}-aarch64-apple-darwin

deactivate
