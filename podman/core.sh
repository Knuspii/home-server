#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="/srv/podman/.env"

if [ -f "$ENV_FILE" ]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Dieses Script muss als root ausgeführt werden."
        exit 1
    fi

    PODMAN_USER="${SUDO_USER:-}"

    if [ -z "$PODMAN_USER" ] || [ "$PODMAN_USER" = "root" ]; then
        echo "Bitte mit sudo ausführen, z.B.: sudo bash start.sh"
        exit 1
    fi

    PODMAN_UID="$(id -u "$PODMAN_USER")"
    PODMAN_HOME="$(getent passwd "$PODMAN_USER" | cut -d: -f6)"
    PODMAN_RUNTIME="/run/user/$PODMAN_UID"
}

init_script() {
    if [ -z "${NAME:-}" ]; then
        echo "NAME ist nicht gesetzt."
        exit 1
    fi

    if [ -z "${IMAGE:-}" ]; then
        echo "IMAGE ist nicht gesetzt."
        exit 1
    fi

    echo "* Restarting ${NAME}..."
    echo "* Pulling ${IMAGE}..."

    podman_user pull "$IMAGE"
}

prepare_dir() {
    local dir="$1"

    mkdir -p "$dir"
    chown "$PODMAN_USER:$PODMAN_USER" "$dir"
}

podman_user() {
    runuser -u "$PODMAN_USER" -- env \
        HOME="$PODMAN_HOME" \
        XDG_RUNTIME_DIR="$PODMAN_RUNTIME" \
        podman "$@"
}

stop_container() {
    podman_user stop "$NAME" >/dev/null 2>&1 || true
    podman_user rm "$NAME" >/dev/null 2>&1 || true
}

create_network() {
    podman_user network inspect "$1" >/dev/null 2>&1 \
        || podman_user network create "$1"
}

run_container() {
    podman_user run -d \
        --name "$NAME" \
        "$@"
}

finish() {
    echo "* ${NAME} started!"
}

require_root
init_script
