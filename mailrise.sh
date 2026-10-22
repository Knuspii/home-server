#!/usr/bin/env bash
set -euo pipefail

SMTP_HOST="localhost"
SMTP_PORT="8025"
MAIL_FROM="server@home-server.home"
MAIL_TO="mail@mailrise.home"
TITLE="Home-Server"

msg="${1:-Keine Nachricht angegeben}"

{
    printf 'From: %s\r\n' "$MAIL_FROM"
    printf 'To: %s\r\n' "$MAIL_TO"
    printf 'Subject: %s\r\n' "$TITLE"
    printf 'Content-Type: text/plain; charset=UTF-8\r\n'
    printf '\r\n'
    printf '%s\r\n' "$msg"
} | curl --fail --silent --show-error --max-time 10 \
    --url "smtp://${SMTP_HOST}:${SMTP_PORT}" \
    --mail-from "$MAIL_FROM" \
    --mail-rcpt "$MAIL_TO" \
    --upload-file -

echo
