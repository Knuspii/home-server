#!/usr/bin/env bash
set -e

NAME=vaultwarden
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 9001:80 \
    -e TZ="$TZ" \
    -e DOMAIN=https://vault.knuspii.net \
    -e SIGNUPS_ALLOWED=false \
    -e ADMIN_TOKEN="$VAULTWARDEN_TOKEN" \
    -v "${SCRIPT_DIR}/data:/data:rw" \
    docker.io/vaultwarden/server:latest

finish
