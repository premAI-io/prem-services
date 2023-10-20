#!/bin/bash
# ./setup-petals.sh --model_path ./models/models--petals-team--StableBeluga2 --dht_prefix StableBeluga2-hf --port 8794

# Check if the required environment variables are set
if [ -z "$PREM_PYTHON" ]; then
    echo "Please set the required PREM_PYTHON environment variable."
    echo "Example: export PREM_PYTHON=appdir/envs/prem_env/bin/python"
    exit 1
fi

# Define the paths based on environment variables
python_exec="${PREM_PYTHON:-python}"

# Clone the GitHub repository if not already present
if [ ! -d "prem-services" ]; then
    # only clone the required directory - https://stackoverflow.com/a/52269934
    git clone -n --depth=1 --filter=tree:0 https://github.com/premAI-io/prem-services.git
    git -C prem-services sparse-checkout set --no-cone cht-petals
    git -C prem-services checkout
else
    echo "Using the existing 'prem-services' directory."
fi

# Install requirements using the specified Python binary
"$python_exec" -m pip install -r prem-services/cht-petals/requirements.txt

# Check for the --model_path, --dht_prefix, and --port parameters and run main.py
while [[ $# -gt 0 ]]; do
    case "$1" in
        --model_path)
            model_path="$2"
            shift 2
            ;;
        --dht_prefix)
            dht_prefix="$2"
            shift 2
            ;;
        --port)
            port="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

if [ -n "$model_path" ] && [ -n "$dht_prefix" ] && [ -n "$port" ]; then
    export PYTHONPATH="$(pwd)/prem-services"
    "$python_exec" prem-services/cht-petals/main.py --model_path "$model_path" --dht_prefix "$dht_prefix" --port $port
else
    echo "Please provide the --model_path parameter with the path to the model directory, the --dht_prefix parameter for the DHT prefix, and the --port parameter for the port number."
    exit 1
fi
