#!/usr/bin/env bash
# Script for checking disks health
# Run daily via cron:
# 0 0 * * * bash /srv/check_disks.sh

DISKS=("/dev/sda" "/dev/sdb" "/dev/sdc")
source /srv/podman/.env
#source /srv/logging.sh

#--- ROOT-CHECK ---
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root/sudo."
    exit 1
fi

echo "--- Checking Disks ---"

for DISK in "${DISKS[@]}"; do
    # Check if the disk device exists
    if [ ! -b "$DISK" ]; then
        error="[ERROR] $DISK does not exist."
        echo "${error}"
        exit 1
    fi
    # Read the overall SMART health status (PASSED or FAILED)
    STATUS=$(/usr/sbin/smartctl -H "$DISK" 2>/dev/null | grep -Ei "health status|test result" | awk -F: '{print $2}' | xargs)

    # Evaluate the status result
    if [ "$STATUS" = "PASSED" ] || [ "$STATUS" = "OK" ]; then
        echo "[OK] $DISK: Healthy ($STATUS). No action needed."
    elif [ -z "$STATUS" ]; then
	error="[WARNING] $DISK: SMART status could not be read."
        echo "${error}"
        exit 1
    else
	error="[CRITICAL] $DISK: FAILED ($STATUS)! REPLACE THIS DRIVE IMMEDIATELY."
        echo "${error}"
        exit 1
    fi
done
echo "----------------------"
curl -m 10 --retry 5 "${HC_URL}/disk-health"
