FROM huggingface/transformers-pytorch-gpu:latest

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY . .

CMD python3 main.py
