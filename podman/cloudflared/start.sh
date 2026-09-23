#!/usr/bin/env bash
set -e

NAME=cloudflared
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

stop_container

run_container \
    --network host \
    -e TUNNEL_TOKEN="$TUNNEL_TOKEN" \
    docker.io/cloudflare/cloudflared:latest \
    tunnel --no-autoupdate run

finish
