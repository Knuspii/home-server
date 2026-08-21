#!/usr/bin/env bash

source /srv/docker/.env

# Check running containers
FAILED=$(docker ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    # ALL OK (status=up)
    MSG="All_OK"
    curl -s "${PUSH_URL}?status=up&msg=${MSG}" > /dev/null
    echo "Sending UP: $MSG"
else
    # FAILED (status=down)
    MSG="FAILED:_${FAILED//$'\n'/,_}"
    curl -s "${PUSH_URL}?status=down&msg=${MSG}" > /dev/null
    echo "Sending DOWN: $MSG"
fi
