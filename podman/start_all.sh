#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for script in "$SCRIPT_DIR"/*/start.sh; do
    [ -f "$script" ] || continue

    echo
    echo "===== $(basename "$(dirname "$script")") ====="
    bash "$script"
done

echo
echo "===== Alle Container gestartet ====="
