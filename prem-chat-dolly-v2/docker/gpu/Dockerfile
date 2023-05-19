FROM huggingface/transformers-pytorch-gpu:4.28.1

RUN pip install "accelerate>=0.16.0,<1"

WORKDIR /usr/src/app/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r ./requirements.txt --upgrade pip

COPY download.py .

RUN python3 download.py

COPY . .

CMD python3 main.py
