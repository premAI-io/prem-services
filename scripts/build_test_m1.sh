echo "Building and testing t5 based models"
docker buildx build --file ./prem-copilot-t5/docker/m1/Dockerfile --build-arg="MODEL_ID=Salesforce/codet5p-220m-py" --tag prem-copilot-t5 ./prem-copilot-t5
docker run --rm --name prem-copilot-t5 prem-copilot-t5 pytest

echo "Building and testing llama_cpp based models"
docker buildx build --file ./prem-chat-llama-cpp/docker/m1/Dockerfile --build-arg="MODEL_ID=vicuna-7b-q4" --tag prem-chat-llama-cpp ./prem-chat-llama-cpp
docker run --rm --name prem-chat-llama-cpp prem-chat-llama-cpp pytest
