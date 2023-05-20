FROM huggingface/transformers-pytorch-gpu:latest

ARG MODEL_ID
ARG DEVICE

WORKDIR /usr/src/app/

COPY requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

RUN python3 download.py --model $MODEL_ID

ENV MODEL_ID=$MODEL_ID
ENV DEVICE=$DEVICE

CMD python3 main.py
