#!/usr/bin/env bash
set -e

NAME=vaultwarden
IMAGE=docker.io/vaultwarden/server:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 5001:80 \
    -e TZ="$TZ" \
    -e DOMAIN="https://vault.home" \
    -e SIGNUPS_ALLOWED=false \
    -e ADMIN_TOKEN="$VAULTWARDEN_TOKEN" \
    -e TRASH_AUTO_DELETE_DAYS=30 \
    -e CLIENT_SUPPRESS_ONBOARDING=true \
    -v "${SCRIPT_DIR}/data:/data:rw" \
    "$IMAGE"

finish
