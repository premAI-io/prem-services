FROM huggingface/transformers-pytorch-gpu:latest

ARG MODEL_ID
ARG REFINER_ID

WORKDIR /usr/src/app/

COPY requirements.txt /usr/src/app/

RUN pip3 install --no-cache-dir -r requirements.txt

COPY download.py .

RUN python3 download.py --model $MODEL_ID --refiner "$REFINER_ID"

COPY . .

ENV MODEL_ID=$MODEL_ID
ENV REFINER_ID=$REFINER_ID
ENV DEVICE=cuda

CMD python3 main.py
