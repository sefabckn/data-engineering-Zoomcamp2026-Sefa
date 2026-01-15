FROM python:3.13.11-slim

RUN python -m pip install pandas pyarrow

WORKDIR /code

COPY  pipeline.py .

CMD ["python", "pipeline.py"]

