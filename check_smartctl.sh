#!/usr/bin/env bash
# Script for checking SMART metrics
# Run weekly via cron:
# 0 0 * * 7 bash /srv/check_smartctl.sh

LOGFILE="/srv/logs/smartctl.log"
exec > >(tee -a "$LOGFILE") 2>&1
date

DISKS=("/dev/sda" "/dev/sdb" "/dev/sdc")

#--- ROOT-CHECK ---
if [ "$EUID" -ne 0 ]; then
    echo "Please use sudo/root."
    exit 1
fi

for DISK in "${DISKS[@]}"; do
HEALTH=$(/usr/sbin/smartctl -H "$DISK" 2>/dev/null | grep -o "PASSED")

if [ "$HEALTH" != "PASSED" ]; then
    bash /srv/send_pushover.sh "$DISK UNHEALTHY"
else
    echo "$DISK $HEALTH"
fi
done
