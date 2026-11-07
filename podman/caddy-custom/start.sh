#!/usr/bin/env bash
set -e

NAME=caddy-custom
IMAGE=ghcr.io/knuspii/caddy-cloudflare:latest

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 8000:80 \
    --publish 443:443 \
    --security-opt=no-new-privileges \
    --add-host=host.containers.internal:host-gateway \
    -e "CF_API_TOKEN=${CF_API_TOKEN}" \
    -v "${SCRIPT_DIR}/data/Caddyfile:/etc/caddy/Caddyfile:ro" \
    -v "${SCRIPT_DIR}/data:/data:rw" \
    -v "${SCRIPT_DIR}/www:/srv/www:ro" \
    "$IMAGE"

# Restart Visitor Counter
echo "* Restarting view-counter..."
pkill -f "$SCRIPT_DIR/www/view-counter/server.py" 2>/dev/null || true
sudo -u $PODMAN_USER nohup python3 "$SCRIPT_DIR/www/view-counter/server.py" \
    >/dev/null 2>&1 &

finish
