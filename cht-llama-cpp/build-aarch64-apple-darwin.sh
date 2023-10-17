#!/bin/bash
set -e
export VERSION=1.0.0

virtualenv venv -p=3.11
source ./venv/bin/activate
pip install -r requirements.txt pyinstaller
LLAMA_CPP_PATH=$(python -c 'import llama_cpp; print(llama_cpp.__path__[0])')
# macOS (dylib) package
NAME=mistral-aarch64-apple-darwin
pyinstaller --onefile \
  --target-arch arm64 \
  --add-binary "$LLAMA_CPP_PATH/libllama.dylib:llama_cpp" \
  --name=$NAME \
  --paths ./venv/lib/python3.11/site-packages \
  main.py

if test -f $GITHUB_OUTPUT; then
  echo "bin_name=$NAME" >> $GITHUB_OUTPUT
  echo "bin_path=${PWD}/dist/$NAME" >> $GITHUB_OUTPUT
fi
