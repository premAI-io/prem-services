# Documentation

## Download the Models

e.g.,

```bash
wget https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q5_0.gguf
```

## Compile the Backend

```bash
virtualenv venv -p=3.10
source ./venv/bin/activate
pip install -r requirements.txt
pip install pyinstaller
LLAMA_CPP_PATH=$(python -c "import llama_cpp; print(llama_cpp.__path__[0])")
pyinstaller --onefile --add-binary "$LLAMA_CPP_PATH/libllama.dylib:llama_cpp" --name=chat-service --paths ./venv/lib/python3.10/site-packages main.py
```

## Run the compiled file

```bash
./dist/chat-service
```
