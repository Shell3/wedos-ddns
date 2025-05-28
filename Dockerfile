FROM python:3-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src .

RUN apk update && apk add --no-cache dcron tzdata && \
    rm -rf /var/cache/apk/*

ENV TZ=Europe/Prague

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN touch /var/log/cron.log

ENV CRON_INTERVAL="0 * * * *"

ENTRYPOINT ["/entrypoint.sh"]