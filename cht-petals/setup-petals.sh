#!/bin/bash
# ./setup-petals.sh --model-path ./models/models--petals-team--StableBeluga2 --dht-prefix StableBeluga2-hf --port 8794

tmpdir="${PREM_APPDIR:-.}/$(uuid)"

# clone source
git clone -n --depth=1 --filter=tree:0 https://github.com/premAI-io/prem-services.git "$tmpdir"
git -C "$tmpdir" sparse-checkout set --no-cone cht-petals
git -C "$tmpdir" checkout
# install deps
"${PREM_PYTHON:-python}" -m pip install -r "$tmpdir/cht-petals/requirements.txt" || :
# run server
PYTHONPATH="$tmpdir/cht-petals" "${PREM_PYTHON:-python}" "$tmpdir/cht-petals/main.py" "$@" || :

rm -rf "$tmpdir"
