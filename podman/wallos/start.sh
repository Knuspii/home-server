#!/usr/bin/env bash
set -e

NAME=wallos
IMAGE=docker.io/bellamy/wallos:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 5004:80 \
    -e TZ="$TZ" \
    -v "${SCRIPT_DIR}/data:/var/www/html/db" \
    "$IMAGE"

finish
