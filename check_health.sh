#!/usr/bin/env bash
# Script for checking server health
# Run daily via cron:
# 0 15 * * * bash /srv/check_health.sh

source /srv/podman/.env

#--- ROOT-CHECK ---
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root/sudo."
    exit 1
fi

if sudo server-vibecheck --log /srv/logs/server-vibecheck.log | grep -q "WARN"; then
    echo "Warning detected"
    curl -m 10 --retry 5 "${HEALTH_PUSH}?status=down"
else
    echo "Everything OK"
    curl -m 10 --retry 5 "${HEALTH_PUSH}?status=up"
fi
