#!/bin/sh

CRON_SCHEDULE="${CRON_INTERVAL:-0 * * * *}"

echo "$CRON_SCHEDULE /usr/local/bin/python /app/wedos-updatedns.py >> /var/log/cron.log 2>&1" > /etc/crontabs/root

crond -f