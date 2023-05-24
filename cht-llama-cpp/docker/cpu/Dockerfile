FROM python:3.10-slim-bullseye

ARG MODEL_ID

RUN apt update && apt install -y libopenblas-dev ninja-build build-essential wget
RUN python -m pip install --upgrade pip pytest cmake scikit-build setuptools

WORKDIR /usr/src/app/

RUN wget https://prem-models.s3.eu-central-1.amazonaws.com/${MODEL_ID}.bin
RUN mkdir -p ./ml/models/
RUN mv ${MODEL_ID}.bin ./ml/models/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY . .

ENV MODEL_ID=$MODEL_ID

CMD python main.py
