#!/usr/bin/env bash
set -e

NAME=filebrowser-quantum
IMAGE=gtstef/filebrowser:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --cap-add=NET_BIND_SERVICE \
    --publish 5004:80 \
    -v /mnt/data:/folder:rw \
    -v "${SCRIPT_DIR}/data:/home/filebrowser/data:rw" \
    "$IMAGE"

finish
