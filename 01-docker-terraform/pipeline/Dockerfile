FROM python:3.13.11-slim

# Lets steal a tool of uv without bringing the whole docker image with this command: 
    # Take the uv executable from the official uv image and copy it into my image so I can use it.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/  

COPY pyproject.toml .python-version uv.lock ./ 

RUN python -m pip install pandas pyarrow

RUN uv sync --locked

WORKDIR /code

COPY  pipeline.py .

ENTRYPOINT ["uv", "run", "python", "pipeline.py"]


