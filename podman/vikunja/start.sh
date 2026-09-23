#!/usr/bin/env bash
set -e

NAME=vikunja
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --publish 8001:3456 \
    -e TZ="$TZ" \
    -e VIKUNJA_SERVICE_SECRET="$VIKUNJA_SECRET" \
    -e VIKUNJA_SERVICE_PUBLICURL='http://192.168.178.100:8001' \
    -e VIKUNJA_SERVICE_ENABLEREGISTRATION=false \
    -e VIKUNJA_DATABASE_TYPE=sqlite \
    -e VIKUNJA_DATABASE_PATH=/app/vikunja/files/vikunja.db \
    -v "${SCRIPT_DIR}/data:/app/vikunja/files:rw" \
    docker.io/vikunja/vikunja:latest

finish
