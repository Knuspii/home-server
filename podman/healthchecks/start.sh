
#!/usr/bin/env bash
set -e

NAME=healthchecks
IMAGE=docker.io/healthchecks/healthchecks:latest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../core.sh"
source /srv/podman/.env

prepare_dir "$SCRIPT_DIR/data"

stop_container

run_container \
    --userns=keep-id:uid=999,gid=999 \
    --publish 8001:8000 \
    --security-opt=no-new-privileges \
    -e DB=sqlite \
    -e DB_NAME=/data/hc.sqlite \
    -e SECRET_KEY="$HC_KEY" \
    -e DEBUG=False \
    -e REGISTRATION_OPEN=False \
    -e SECURE_PROXY_SSL_HEADER=HTTP_X_FORWARDED_PROTO,https \
    -e PUSHOVER_API_TOKEN="$PUSHOVER_API" \
    -e PUSHOVER_SUBSCRIPTION_URL="$PUSHOVER_URL" \
    -e SITE_ROOT=https://hc.knuspii.net \
    -e ALLOWED_HOSTS=hc.knuspii.net \
    -v "${SCRIPT_DIR}/data:/data" \
    "$IMAGE"

finish
