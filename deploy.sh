#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/custom_components/enhanced_input"
REMOTE_DIR="/config/custom_components/enhanced_input/"

usage() {
    echo "Usage: $0 <ssh-host>"
    echo
    echo "  ssh-host  SSH host as defined in ~/.ssh/config (required)"
    exit 1
}

if [[ $# -lt 1 ]]; then
    usage
fi

HOST="$1"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "Error: source directory not found: $SOURCE_DIR"
    exit 1
fi

echo "Deploying enhanced_input to $HOST:$REMOTE_DIR"
scp -r "$SOURCE_DIR"/* "$HOST:$REMOTE_DIR"
echo "Done. Restart Home Assistant to pick up changes."
