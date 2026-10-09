#!/usr/bin/env bash
# Check if podman containers are down
# Run via cron:
# */30 * * * * bash /srv/check_podman.sh

OUTPUT="/srv/logs/podman.log"
source /srv/logging.sh

# Check running containers
FAILED=$(sudo -iu user podman ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    # ALL OK (status=up)
    echo "UP!"
    echo up > $OUTPUT
else
    # FAILED (status=down)
    echo "DOWN!"
    echo down > $OUTPUT
    bash /srv/send_gotify.sh "Podman Container down!"
fi
