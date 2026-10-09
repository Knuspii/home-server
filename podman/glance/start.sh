#!/usr/bin/env bash
set -e

NAME=glance
IMAGE=glanceapp/glance:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --read-only \
    --publish 80:8080 \
    -e TZ="$TZ" \
    -e TOKEN_FILE=/app/config/secret \
    -v "${SCRIPT_DIR}/data:/app/config:ro" \
    "$IMAGE"

finish
