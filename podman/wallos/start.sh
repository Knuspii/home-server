#!/usr/bin/env bash
set -e

NAME=wallos
IMAGE=docker.io/bellamy/wallos:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"
prepare_dir "$SCRIPT_DIR/data/logos"

stop_container

run_container \
    --publish 5004:80 \
    --security-opt=no-new-privileges \
    -e TZ="$TZ" \
    -v "${SCRIPT_DIR}/data:/var/www/html/db" \
    -v "${SCRIPT_DIR}/data/logos:/var/www/html/images/uploads/logos" \
    "$IMAGE"

finish
