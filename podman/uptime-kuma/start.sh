#!/usr/bin/env bash
set -e

NAME=uptime-kuma
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 9000:3001 \
    --memory 2000m \
    --cpus 2.0 \
    -v "${SCRIPT_DIR}/data:/app/data:rw" \
    docker.io/louislam/uptime-kuma:2

finish
