#!/bin/bash
# ./setup-petals.sh --model_path ./models/models--petals-team--StableBeluga2 --dht_prefix StableBeluga2-hf
# TODO: replace appdir with ~/.prem/appdir (?)

# Define the Miniconda installation path and environment name
miniconda_path="appdir"
conda_env="prem_env"

# Function to install Miniconda if not already present
install_miniconda() {
    local arch

    if [ "$(uname -s)" == "Darwin" ]; then
        # macOS
        if [ "$1" == "x86_64" ]; then
            arch="x86_64"
        elif [ "$1" == "arm64" ]; then
            arch="arm64"
        else
            echo "Unsupported architecture: $1"
            exit 1
        fi
    elif [ "$(uname -s)" == "Linux" ]; then
        # Linux
        if [ "$1" == "x86_64" ]; then
            arch="x86_64"
        elif [ "$1" == "aarch64" ]; then
            arch="aarch64"
        elif [ "$1" == "armv7l" ]; then
            arch="armv7l"
        else
            echo "Unsupported architecture: $1"
            exit 1
        fi
    else
        echo "Unsupported operating system: $(uname -s)"
        exit 1
    fi

    # Create the 'appdir' directory if it doesn't exist
    if [ ! -d "$miniconda_path" ]; then
        mkdir "$miniconda_path"

        # Download and install Miniconda based on OS and architecture
        if [ "$(uname -s)" == "Darwin" ]; then
            wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-$arch.sh" -O miniconda_installer.sh
        elif [ "$(uname -s)" == "Linux" ]; then
            wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$arch.sh" -O miniconda_installer.sh
        fi

        bash miniconda_installer.sh -b -u -p "$miniconda_path"
        rm miniconda_installer.sh
    else
        echo "Using existing Miniconda in '$miniconda_path'."
    fi
}

# Check if Miniconda is already installed
if ! command -v "$miniconda_path/bin/conda" &>/dev/null; then
    install_miniconda "$(arch | cut -d_ -f2)"
fi

# Check if the Miniconda environment 'prem_env' exists
if [ ! -d "$miniconda_path/envs/$conda_env" ]; then
    "$miniconda_path/bin/conda" create -n "$conda_env" python=3.11 -y
fi

# Clone the GitHub repository if not already present
if [ ! -d "prem-services" ]; then
    # only clone the required directory - https://stackoverflow.com/a/52269934
    git clone -n --depth=1 --filter=tree:0 https://github.com/premAI-io/prem-services.git
    git -C prem-services sparse-checkout set --no-cone cht-petals
    git -C prem-services checkout
else
    echo "Using existing 'prem-services' directory."
fi

# Install requirements in the Miniconda environment
"$miniconda_path/envs/$conda_env/bin/pip" install -r prem-services/cht-petals/requirements.txt

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
    "$miniconda_path/envs/$conda_env/bin/python" prem-services/cht-petals/main.py --model_path "$model_path" --dht_prefix "$dht_prefix"
else
    echo "Please provide the --model_path parameter with the path to model directory and the --dht_prefix parameter for the DHT prefix."
    exit 1
fi
