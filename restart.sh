#!/usr/bin/env bash

# ==============================================================================
# Script: restart.sh
# Description: Restart all Docker Compose services
# ==============================================================================

set -e

cd "$(dirname "$0")"

./stop.sh
echo ""
./start.sh "$@"
