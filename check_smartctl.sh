#!/usr/bin/env bash
# Script for checking SMART remaining lifespan
# Run weekly via cron:
# 0 0 * * 7 bash /srv/check_smartctl.sh

LOGFILE="/srv/logs/smartctl.log"
exec > >(tee -a "$LOGFILE") 2>&1
date

DISKS=("/dev/sda" "/dev/sdb" "/dev/sdc")

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
        bash /srv/send_pushover.sh "${error}"
        continue
    fi

    # Read the overall SMART health status (PASSED or FAILED)
    STATUS=$(/usr/sbin/smartctl -H "$DISK" 2>/dev/null | grep -Ei "health status|test result" | awk -F: '{print $2}' | xargs)

    # Evaluate the status result
    if [ "$STATUS" = "PASSED" ] || [ "$STATUS" = "OK" ]; then
        echo "[OK] $DISK: Healthy ($STATUS). No action needed."
    elif [ -z "$STATUS" ]; then
	error="[WARNING] $DISK: SMART status could not be read."
        echo "${error}"
	bash /srv/send_pushover.sh "${error}"
    else
	error="[CRITICAL] $DISK: FAILED ($STATUS)! REPLACE THIS DRIVE IMMEDIATELY."
        echo "${error}"
        bash /srv/send_pushover.sh "${error}"
    fi
done

echo "-----------------------"
