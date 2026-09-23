#!/usr/bin/env bash

NAME=adguard-home
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$(dirname "$0")/../core.sh"

prepare_dir "$SCRIPT_DIR/data/work"
prepare_dir "$SCRIPT_DIR/data/conf"

stop_container

run_container \
    --network host \
    -e TZ="$TZ" \
    -v "${SCRIPT_DIR}/data/work:/opt/adguardhome/work:rw,Z" \
    -v "${SCRIPT_DIR}/data/conf:/opt/adguardhome/conf:rw,Z" \
    docker.io/adguard/adguardhome:latest

finish
