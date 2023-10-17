# Documentation

## Download the Models

e.g.,

```bash
mkdir -p ./ml/models/
wget -P ./ml/models/ https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q5_0.gguf
wget -P ./ml/models/ https://huggingface.co/TheBloke/Mistral-7B-OpenOrca-GGUF/resolve/main/mistral-7b-openorca.Q5_K_S.gguf
```

## Compile the Backend

```bash
virtualenv venv -p=3.10
source ./venv/bin/activate
pip install -r requirements.txt pyinstaller
LLAMA_CPP_PATH=$(python -c 'import llama_cpp; print(llama_cpp.__path__[0])')
# macOS (dylib) package
pyinstaller --onefile --add-binary "$LLAMA_CPP_PATH/libllama.dylib:llama_cpp" --name=chat-service --paths ./venv/lib/python3.10/site-packages main.py
```

## Run the compiled file

```bash
./dist/chat-service
```
