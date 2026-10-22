#!/usr/bin/env bash
set -e

NAME=vikunja
IMAGE=docker.io/vikunja/vikunja:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --publish 5002:3456 \
    -e TZ="$TZ" \
    -e VIKUNJA_SERVICE_SECRET="$VIKUNJA_SECRET" \
    -e VIKUNJA_SERVICE_ENABLEREGISTRATION=false \
    -e VIKUNJA_SERVICE_PUBLICURL=http://192.168.178.100:5002 \
    -e VIKUNJA_DATABASE_TYPE=sqlite \
    -e VIKUNJA_DATABASE_PATH=/app/vikunja/files/vikunja.db \
    -e VIKUNJA_MAILER_ENABLED=true \
    -e VIKUNJA_MAILER_HOST=host.containers.internal \
    -e VIKUNJA_MAILER_FORCESSL=false \
    -e VIKUNJA_MAILER_PORT=8025 \
    -e VIKUNJA_MAILER_USERNAME=mail@mailrise.home \
    -v "${SCRIPT_DIR}/data:/app/vikunja/files:rw" \
    "$IMAGE"

finish
