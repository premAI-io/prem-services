echo "Building and testing t5 based models"
docker buildx build --file ./copilot-t5/docker/m1/Dockerfile --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" --tag copilot-t5 ./copilot-t5
docker run --rm --name copilot-t5 copilot-t5 pytest

echo "Building and testing llama_cpp based models"
docker buildx build --file ./chat-llama-cpp/docker/m1/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag chat-llama-cpp ./chat-llama-cpp
docker run --rm --name chat-llama-cpp chat-llama-cpp pytest
