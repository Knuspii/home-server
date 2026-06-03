#!/usr/bin/env bash
# Script for checking SMART metrics
# Run weekly via cron:
# 0 0 * * 7 bash /srv/check_smartctl.sh

DISKS=("/dev/sda" "/dev/sdb")

#--- ROOT-CHECK ---
if [ "$EUID" -ne 0 ]; then
    echo "Please use sudo/root."
    exit 1
fi

for DISK in "${DISKS[@]}"; do
HEALTH=$(smartctl -H "$DISK" 2>/dev/null | grep -o "PASSED")

if [ "$HEALTH" != "PASSED" ]; then
    bash /srv/send_gotify.sh "$DISK $HEALTH"
else
    echo "$DISK $HEALTH"
fi
done
