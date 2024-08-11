FROM python:3.9.19-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY .. /app

EXPOSE 8080

ENV NAME World

CMD ["python", "app.py"]
