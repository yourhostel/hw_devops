FROM python:3.8-slim

RUN apt-get update && apt-get install -y \
    procps \
    net-tools \
    procps \
 && rm -rf /var/lib/apt/lists/* \

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app/ .
CMD ["python", "main.py"]