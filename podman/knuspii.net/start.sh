#!/usr/bin/env bash
set -e

NAME=nginx
IMAGE=docker.io/library/nginx:alpine
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/www"
prepare_dir "$SCRIPT_DIR/data"
stop_container

run_container \
    --publish 8000:80 \
    -e TZ="$TZ" \
    -v "${SCRIPT_DIR}/www:/usr/share/nginx/html:ro" \
    -v "${SCRIPT_DIR}/data:/etc/nginx/conf.d/:ro" \
    "$IMAGE"

finish
