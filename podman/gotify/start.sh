#!/usr/bin/env bash
set -e

NAME=gotify
IMAGE=docker.io/gotify/server:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 8001:80 \
    -e TZ="$TZ" \
    -e GOTIFY_SERVER_SECURECOOKIE=true \
    -v "${SCRIPT_DIR}/data:/app/data:rw" \
    "$IMAGE"

finish
