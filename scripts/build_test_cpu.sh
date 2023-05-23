echo "Building and testing stable diffusion based models"
docker buildx build --file ./michelangelo-sd/docker/cpu/Dockerfile --build-arg="MODEL_ID=stabilityai/stable-diffusion-2-1-base" --tag michelangelo-sd ./michelangelo-sd
docker run --rm --name michelangelo-sd michelangelo-sd pytest

echo "Building and testing t5 based models"
docker buildx build --file ./copilot-t5/docker/cpu/Dockerfile --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" --tag copilot-t5 ./copilot-t5
docker run --rm --name copilot-t5 copilot-t5 pytest

echo "Building and testing llama_cpp based models"
docker buildx build --file ./chat-llama-cpp/docker/cpu/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag chat-llama-cpp ./chat-llama-cpp
docker run --rm --name chat-llama-cpp chat-llama-cpp pytest
