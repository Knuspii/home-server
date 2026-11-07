#!/usr/bin/env bash
set -e

NAME=microbin
IMAGE=docker.io/danielszabo99/microbin:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --publish 8002:8080 \
    --security-opt=no-new-privileges \
    -e TZ="$TZ" \
    -e MICROBIN_ADMIN_USERNAME="$MICROBIN_USERNAME" \
    -e MICROBIN_ADMIN_PASSWORD="$MICROBIN_ADMIN_PASSWORD" \
    -e MICROBIN_UPLOADER_PASSWORD="$MICROBIN_UPLOADER_PASSWORD" \
    -e MICROBIN_PUBLIC_PATH=https://bin.knuspii.net \
    -e MICROBIN_FOOTER_TEXT="Ah yes, my MicroBin! (you need a password to upload stuff)" \
    -e MICROBIN_QR=true \
    -e MICROBIN_READONLY=true \
    -e MICROBIN_EDITABLE=false \
    -e MICROBIN_DEFAULT_PRIVACY=unlisted \
    -e MICROBIN_ENCRYPTION_CLIENT_SIDE=true \
    -e MICROBIN_ENCRYPTION_SERVER_SIDE=true \
    -e MICROBIN_DISABLE_TELEMETRY=true \
    -v "${SCRIPT_DIR}/data:/app/microbin_data:rw" \
    "$IMAGE"

finish
