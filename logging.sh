#!/usr/bin/env bash

LOG_DIR="/srv/logs"
mkdir -p "$LOG_DIR"

SCRIPT_NAME="$(basename "$0" .sh)"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "######################################"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Started"
