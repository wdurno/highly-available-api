FROM alpine

ADD app /app

RUN apk --update --no-cache add \
        bash \
        ca-certificates \
        curl \
        openssl \
        python3 \
        py3-pip && \
    pip install -r /app/requirements.txt 

ENTRYPOINT ["bash", "/app/entrypoint.sh"]

