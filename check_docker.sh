#!/usr/bin/env bash

# --- Config ---
source /srv/docker/.env
PUSH_URL="${PUSH_URL}"

# Find containers that are NOT "running"
# We only extract the names of affected containers
FAILED=$(docker ps -a --format "{{.Names}} {{.Status}}" | grep -v "Up" | awk '{print $1}')

if [ -z "$FAILED" ]; then
    # ALL GOOD: All containers are running
    MSG="All_Docker_Containers_OK"
    curl -s "${PUSH_URL}" > /dev/null
    echo "Sending UP: $MSG"
else
    # ALERT: At least one container has issues
    # We send the list of container names in the message parameter
    MSG="FAILED:_${FAILED//$'\n'/,_}" # Replace newlines with commas for URL safety
    curl -s "${PUSH_URL}/fail" > /dev/null
    echo "Sending DOWN: $MSG"
fi
