#!/usr/bin/env bash
set -e

NAME=caddy
IMAGE=docker.io/library/caddy:latest

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 443:443/tcp \
    --publish 443:443/udp \
    -v "${SCRIPT_DIR}/data/Caddyfile:/etc/caddy/Caddyfile:ro" \
    -v "${SCRIPT_DIR}/data:/data:rw" \
    --add-host=host.containers.internal:host-gateway \
    "$IMAGE"

finish
