#!/usr/bin/env bash

# ==============================================================================
# Script: stop.sh
# Description: Gracefully stop all Docker Compose services for the application
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Ensure we run from the project root
cd "$(dirname "$0")"

echo -e "${CYAN}${BOLD}"
echo "=========================================================="
echo "    Stopping OTP 2025 (Laravel 13 Application Stack)      "
echo "=========================================================="
echo -e "${NC}"

# Parse flags
REMOVE_VOLUMES=false
FORCE=false

for arg in "$@"; do
    case $arg in
        -v|--volumes)
            REMOVE_VOLUMES=true
            ;;
        -f|--force)
            FORCE=true
            ;;
    esac
done

if [ "$REMOVE_VOLUMES" = true ]; then
    if [ "$FORCE" != true ]; then
        echo -e "${RED}${BOLD}[WARNING] You passed -v / --volumes.${NC}"
        read -p "Are you sure you want to remove all database volumes? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Aborted volume removal. Stopping containers normally...${NC}"
            docker compose down
            echo -e "${GREEN}✓ All services stopped successfully.${NC}"
            exit 0
        fi
    fi
    echo -e "${YELLOW}▶ Stopping services and removing volumes...${NC}"
    docker compose down -v
    echo -e "${GREEN}✓ All services stopped and volumes removed.${NC}"
else
    echo -e "${BLUE}▶ Stopping all Docker Compose services...${NC}"
    docker compose down
    echo -e "${GREEN}✓ All services stopped successfully.${NC}"
fi

echo "=========================================================="
echo ""
