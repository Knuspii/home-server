#!/usr/bin/env bash
set -e

NAME=filebrowser-quantum
IMAGE=docker.io/gtstef/filebrowser:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --publish 5003:8080 \
    --security-opt=no-new-privileges \
    -v /mnt/data:/folder:rw \
    -v "${SCRIPT_DIR}/data:/home/filebrowser/data:rw" \
    "$IMAGE"

finish
