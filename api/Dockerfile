FROM alpine

ADD app /app

RUN apk --update --no-cache add \
        bash \
        ca-certificates \
        curl \
        openssl \
        python3 \
        py3-pip \
        py3-psycopg2 && \
    pip install -r /app/requirements.txt 

WORKDIR /app

