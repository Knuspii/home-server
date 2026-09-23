#!/usr/bin/env bash

source /srv/podman/.env

# Check running containers
FAILED=$(sudo -u user podman ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    # ALL OK (status=up)
    MSG="All_OK"
    curl -m 10 --retry 5 "${PODMAN_PUSH}?status=up&msg=${MSG}" > /dev/null
    echo "Sending UP: $MSG"
else
    # FAILED (status=down)
    MSG="FAILED:_${FAILED//$'\n'/,_}"
    curl -m 10 --retry 5 "${PODMAN_PUSH}?status=down&msg=${MSG}" > /dev/null
    echo "Sending DOWN: $MSG"
fi
