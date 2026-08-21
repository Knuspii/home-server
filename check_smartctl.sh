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

for DISK in "${DISKS[@]}"; do
    # Extract VALUE from the first matching wear/lifespan ID
    RAW_VAL=$(/usr/sbin/smartctl -A "$DISK" 2>/dev/null | awk '$1 ~ /^(201|230|231|232|233)$/ {print $4; exit}')

    if [ -z "$RAW_VAL" ]; then
        echo "$DISK: Could not read Lifetime_Remaining%"
        continue
    fi

    # Strip leading zeros
    LIFETIME=$((10#$RAW_VAL))

    echo "$DISK Lifetime Remaining: ${LIFETIME}%"

    if [ "$LIFETIME" -lt 20 ]; then
        bash /srv/send_pushover.sh "$DISK Lifetime Low: ${LIFETIME}% remaining"
    fi
done
