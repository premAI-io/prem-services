FROM huggingface/transformers-pytorch-gpu:latest

ARG MODEL_ID

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY download.py .

RUN python3 download.py

COPY . .

ENV MODEL_ID=$MODEL_ID

CMD python3 main.py
