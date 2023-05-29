FROM huggingface/transformers-pytorch-gpu:4.28.1

ARG MODEL_ID

RUN pip install "accelerate>=0.16.0,<1"

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY download.py .

RUN python3 download.py --model $MODEL_ID

COPY . .

ENV MODEL_ID=$MODEL_ID
ENV DEVICE=auto

CMD python3 main.py
