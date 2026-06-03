#!/usr/bin/env bash
# Server Cleanup Script (Docker + System)
# Run monthly via cron:
# 0 0 1 * * bash /srv/cleanup.sh

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

# Get free disk space (KB)
get_free_space() {
    df / --output=avail | tail -1
}

PRE_CLEAN=$(get_free_space)

echo "--- Starting server cleanup ---"

# 1. APT cleanup
if command -v apt-get &> /dev/null; then
    echo "[APT] Cleaning package cache..."
    apt-get update > /dev/null
    apt-get autoclean -y > /dev/null
    apt-get clean
    apt-get autoremove -y > /dev/null
fi

# 2. Containers (Docker / Podman)
if command -v docker &> /dev/null; then
    echo "[DOCKER] Cleaning unused resources..."
    docker system prune -a -f > /dev/null
elif command -v podman &> /dev/null; then
    echo "[PODMAN] Cleaning unused resources... (as podman user)"
    sudo user -u podman podman system prune -a -f > /dev/null
fi

# 3. System logs (journald)
echo "[LOGS] Vacuum logs older than 7 days..."
journalctl --vacuum-time=7d > /dev/null

# 4. Temp files (safe cleanup)
echo "[TEMP] Cleaning old temp files..."
find /tmp -mindepth 1 -mtime +7 -delete 2>/dev/null || true
find /var/tmp -mindepth 1 -mtime +7 -delete 2>/dev/null || true

echo "--- Cleanup finished ---"

POST_CLEAN=$(get_free_space)
RECLAIMED_KB=$((POST_CLEAN - PRE_CLEAN))

if [ "$RECLAIMED_KB" -le 0 ]; then
    echo "No significant space reclaimed."
else
    RECLAIMED_HUMAN=$(numfmt --to=iec --suffix=B "$((RECLAIMED_KB * 1024))")
    echo "Space reclaimed: $RECLAIMED_HUMAN"
fi

echo "Current disk usage:"
df -h /
