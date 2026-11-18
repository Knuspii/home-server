#!/usr/bin/env bash
# Script to tidy up my fu***** server
# Run via cron:
# 0 1 * * * bash /srv/daily_janitor.sh

set -Eeu

PODMAN_USER="user"
DISKS=("/dev/sda" "/dev/sdb" "/dev/sdc")
source /srv/podman/.env
date

ping_hc() {
    # Send ping for healthcheck
    curl -fsS -m 10 --retry 3 "${HC_URL}/$1" >/dev/null
}

tidy-up() {
    apt-get update >/dev/null
    # Mount
    find /mnt/data/Temp -mindepth 1 -mtime +7 -delete 2>/dev/null || true
    chown -R user:user /mnt/data/ && chmod -R 700 /mnt/data/ || { echo "[ERROR] chown/chmod failed"; return 1; }
    # Other logs
    find /srv/logs -mindepth 1 -mtime +30 -delete 2>/dev/null || true
    echo "[OK] Tidy up"
}

basic_cleanup() {
    apt-get clean >/dev/null
    sudo -iu "$PODMAN_USER" podman system prune -a -f >/dev/null
    journalctl --vacuum-time=30d >/dev/null
    find /tmp /var/tmp -mindepth 1 -mtime +30 -delete 2>/dev/null || true
    echo "[OK] Cleanup"
}

check_disks() {
    local failed=0
    # SMART Health Check
    for disk in "${DISKS[@]}"; do
        if ! sudo smartctl -H "$disk" | grep -q "PASSED"; then
            echo "[ERROR] SMART Health FAILED: $disk"
            failed=1
        else
            echo "[OK] SMART Health: $disk"
        fi
    done

    # RAID / mdstat Check
    if [[ -r /proc/mdstat ]]; then
        if grep -qE '\[[U_]+\]' /proc/mdstat && grep -q '_' /proc/mdstat; then
            echo "[ERROR] RAID degraded"
            failed=1
        else
            echo "[OK] RAID status"
        fi
    else
        echo "[ERROR] Cannot read /proc/mdstat"
        failed=1
    fi

    # Mountpoint Check
    if mountpoint -q /mnt/data; then
        echo "[OK] /mnt/data mounted"
    else
        echo "[ERROR] /mnt/data not mounted"
        failed=1
    fi

    # Healthchecks ping
    if [[ $failed -eq 0 ]]; then
        ping_hc disks-health
        echo "[OK] Disks & RAID"
    else
        echo "[ERROR] Disk health check failed"
        return 1
    fi
}

tidy-up
basic_cleanup
check_disks
ping_hc daily-janitor
