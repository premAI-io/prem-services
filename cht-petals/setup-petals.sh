#!/bin/bash
# ./setup-petals.sh --model_path ./models/models--petals-team--StableBeluga2 --dht_prefix StableBeluga2-hf
# TODO: replace appdir with ~/.prem/appdir (?)


# Function to install Miniconda
install_miniconda() {
    local arch
    if [ "$1" == "x86_64" ]; then
        arch="x86_64"
    elif [ "$1" == "arm64" ]; then
        arch="arm64"
    else
        echo "Unsupported architecture: $1"
        exit 1
    fi

    # Create the 'appdir' directory if it doesn't exist
    if [ ! -d "appdir" ]; then
        mkdir appdir
    fi

    # Download and install Miniconda
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-"$arch".sh -O miniconda_installer.sh
    bash miniconda_installer.sh -b -u -p appdir
    rm miniconda_installer.sh
}

# Check if 'appdir' directory exists, if not, create it
if [ ! -d "appdir" ]; then
    install_miniconda "$(arch | cut -d_ -f2)"
else
    echo "Using existing 'appdir' directory."
fi

# Activate the Miniconda environment and create 'prem_env'
appdir/bin/conda create -n prem_env python=3.11 -y

# Clone the GitHub repository and install requirements
git clone -n --depth=1 --filter=tree:0 https://github.com/premAI-io/prem-services.git
git -C prem-services sparse-checkout set --no-cone cht-petals
git -C prem-services checkout

appdir/envs/prem_env/bin/pip install -r prem-services/cht-petals/requirements.txt

# Check for the --model_path and --dht_prefix parameters and run main.py
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
        *)
            shift
            ;;
    esac
done

if [ -n "$model_path" ] && [ -n "$dht_prefix" ]; then
    export PYTHONPATH="$(pwd)/prem-services"
    appdir/envs/prem_env/bin/python prem-services/cht-petals/main.py --model_path "$model_path" --dht_prefix "$dht_prefix"
else
    echo "Please provide the --model_path parameter path to model directory and the --dht_prefix parameter for the DHT prefix."
    exit 1
fi
