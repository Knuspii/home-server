#!/usr/bin/env bash
# Check if podman containers are down
# Run via cron:
# */30 * * * * bash /srv/check_podman.sh

PODMAN_USER=user
source /srv/podman/.env
date

# Check running containers
FAILED=$(sudo -iu $PODMAN_USER podman ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    echo "ALL UP!"
    curl -fsS  -m 10 --retry 5 "${HC_URL}/podman-containers"
else
    echo "DOWN! $FAILED"
fi
