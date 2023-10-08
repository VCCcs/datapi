FROM python:3.11

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt && rm requirements.txt

COPY . .

EXPOSE 8000

ENTRYPOINT ["python", "main.py"]