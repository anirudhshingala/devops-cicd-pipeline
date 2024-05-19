FROM python:3.9-slim

RUN apt-get update -y

RUN apt-get install -y \
    curl \
    net-tools

WORKDIR /app

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
