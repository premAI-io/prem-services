FROM huggingface/transformers-pytorch-gpu:4.28.1
WORKDIR /usr/src/app/

RUN cd $(dirname $(which python3)) && ln -s python3 python
RUN apt update -qq && apt install -yqq --no-install-recommends \
    wget unzip \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ARG MODEL_ID
RUN wget https://prem-models.s3.eu-central-1.amazonaws.com/llama-v2/${MODEL_ID}.zip
RUN unzip -o ${MODEL_ID}.zip && rm ${MODEL_ID}.zip

COPY . .
ENV MODEL_ID=$MODEL_ID
CMD python main.py
