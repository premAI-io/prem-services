echo "Building and testing whisper based models"
docker buildx build --file ./audio-to-text-wh/docker/cpu/Dockerfile --build-arg="MODEL_ID=tiny" --tag audio-to-text-wh ./audio-to-text-wh
docker run --rm --name audio-to-text-wh audio-to-text-wh pytest

exit

echo "Building and testing sentence transformers based models"
docker buildx build --file ./embeddings-st/docker/cpu/Dockerfile --build-arg="MODEL_ID=all-MiniLM-L6-v2" --tag embeddings-st ./embeddings-st
docker run --rm --name embeddings-st embeddings-st pytest

echo "Building and testing stable diffusion based models"
docker buildx build --file ./michelangelo-sd/docker/cpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --tag michelangelo-sd ./michelangelo-sd
docker run --rm --name michelangelo-sd michelangelo-sd pytest

echo "Building and testing t5 based models"
docker buildx build --file ./copilot-t5/docker/cpu/Dockerfile --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" --tag copilot-t5 ./copilot-t5
docker run --rm --name copilot-t5 copilot-t5 pytest

echo "Building and testing llama_cpp based models"
docker buildx build --file ./chat-llama-cpp/docker/cpu/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag chat-llama-cpp ./chat-llama-cpp
docker run --rm --name chat-llama-cpp chat-llama-cpp pytest

echo "Building and testing bark based models"
docker buildx build --file ./text-to-audio-ba/docker/cpu/Dockerfile --tag text-to-audio-ba ./text-to-audio-ba
docker run --rm --name text-to-audio-ba text-to-audio-ba pytest
