FROM alpine

ADD app /app

RUN apk --update --no-cache add \
        bash \
	build-base \
        ca-certificates \
        curl \
        openssl \
	libffi-dev \
	libressl-dev \
	musl-dev \
        python3-dev \
        py3-pip \
        py3-psycopg2 && \
    pip install -r /app/requirements.txt 

WORKDIR /app

