#!/usr/bin/env bash
# Check if podman containers are down
# Run via cron:
# */30 * * * * bash /srv/check_podman.sh

PODMAN_USER=user
source /srv/podman/.env
#source /srv/logging.sh

# Check running containers
FAILED=$(sudo -iu $PODMAN_USER podman ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    # ALL OK (status=up)
    echo "UP!"
    curl -m 10 --retry 5 "${HC_URL}/podman-containers"
else
    # FAILED (status=down)
    echo "DOWN!"
fi
