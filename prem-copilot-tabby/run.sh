mkdir -p data/hf_cache && chown -R 1000 data

docker run \
  --gpus all \
  -it --rm \
  -v "/$(pwd)/data:/data" \
  -v "/$(pwd)/data/hf_cache:/home/app/.cache/huggingface" \
  -p 5000:5000 \
  -e MODEL_NAME=TabbyML/J-350M \
  -e MODEL_BACKEND=triton \
  --name=tabby \
  tabbyml/tabby
