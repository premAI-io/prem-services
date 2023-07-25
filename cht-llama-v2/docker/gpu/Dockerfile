FROM huggingface/transformers-pytorch-gpu:4.28.1

ARG MODEL_ID

RUN apt install -y wget unzip

WORKDIR /usr/src/app/

RUN wget https://prem-models.s3.eu-central-1.amazonaws.com/llama-v2/${MODEL_ID}.zip
RUN unzip -o ${MODEL_ID}.zip && rm ${MODEL_ID}.zip

COPY . .

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip


ENV MODEL_ID=$MODEL_ID

CMD python3 main.py
