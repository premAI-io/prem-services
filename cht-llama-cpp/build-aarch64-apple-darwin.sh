#!/bin/bash
set -e

export VERSION=1.1.1

test -f venv/bin/activate || python -m venv venv
source venv/bin/activate


pip install -r requirements.txt pyinstaller
LLAMA_CPP_PATH=$(python -c 'import llama_cpp; print(llama_cpp.__path__[0])')
# macOS (dylib) package
NAME=cht-llama-cpp-mistral-${VERSION}-aarch64-apple-darwin
pyinstaller --onefile \
  --target-arch arm64 \
  --add-binary "$LLAMA_CPP_PATH/libllama.dylib:llama_cpp" \
  --name=$NAME \
  main.py
cp dist/$NAME dist/cht-llama-cpp-mistral-${VERSION%%.*}-aarch64-apple-darwin

deactivate
