FROM huggingface/transformers-pytorch-gpu:latest

ARG MODEL_ID
ARG DEVICE

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY download.py .

RUN python3 download.py --model $MODEL_ID

COPY . .

ENV MODEL_ID=$MODEL_ID
ENV DEVICE=$DEVICE

CMD python3 main.py
