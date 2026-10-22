#!/usr/bin/env bash
set -e

NAME=mailrise
IMAGE=docker.io/yoryan/mailrise:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 8025:8025 \
    -v "${SCRIPT_DIR}/data/mailrise.conf:/etc/mailrise.conf:ro" \
    "$IMAGE"

finish
