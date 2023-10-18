#!/bin/bash
set -e
export VERSION=1.0.0

virtualenv venv -p=3.11
source ./venv/bin/activate
pip install -r requirements.txt pyinstaller
LLAMA_CPP_PATH=$(python -c 'import llama_cpp; print(llama_cpp.__path__[0])')
# macOS (dylib) package
NAME=mistral-${VERSION}-aarch64-apple-darwin
pyinstaller --onefile \
  --target-arch arm64 \
  --add-binary "$LLAMA_CPP_PATH/libllama.dylib:llama_cpp" \
  --name=$NAME \
  --paths ./venv/lib/python3.11/site-packages \
  main.py
cp dist/$NAME dist/mistral-${VERSION%%.*}-aarch64-apple-darwin
