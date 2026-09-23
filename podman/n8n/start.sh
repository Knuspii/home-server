#!/usr/bin/env bash
set -e

NAME=n8n
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id \
    --publish 8002:5678 \
    --memory 2000m \
    --cpus 2.0 \
    -e TZ="$TZ" \
    -e GENERIC_TIMEZONE=Europe/Berlin \
    -e N8N_HOST=n8n.home-server \
    -e N8N_PORT=5678 \
    -e N8N_PROTOCOL=http \
    -e N8N_SECURE_COOKIE=false \
    -e EXECUTIONS_DATA_PRUNE=true \
    -e EXECUTIONS_DATA_MAX_AGE=30 \
    -e EXECUTIONS_DATA_PRUNE_MAX_COUNT=10000 \
    -v "${SCRIPT_DIR}/data:/home/node/.n8n:rw" \
    docker.io/n8nio/n8n:latest

finish
