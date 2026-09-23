#!/usr/bin/env bash
set -e

NAME=gotify
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 9002:80 \
    -e TZ="$TZ" \
    -e GOTIFY_SERVER_SECURECOOKIE=true \
    -v "${SCRIPT_DIR}/data:/app/data:rw" \
    docker.io/gotify/server:latest

finish
