#!/usr/bin/env bash
set -euo pipefail

TITLE="Home-Server"
source /srv/podman/.env

msg="${1:-Keine Nachricht angegeben}"

curl --fail --silent --show-error --max-time 10 \
    --request POST \
    --form-string "token=${PUSHOVER_API}" \
    --form-string "user=${PUSHOVER_USER}" \
    --form-string "title=${TITLE}" \
    --form-string "message=${msg}" \
    https://api.pushover.net/1/messages.json

echo
