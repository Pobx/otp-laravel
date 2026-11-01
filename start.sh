#!/usr/bin/env bash

# ==============================================================================
# Script: start.sh
# Description: Start the Laravel Application stack using Docker Compose
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
echo "    Starting OTP 2025 (Laravel 13 Application Stack)      "
echo "=========================================================="
echo -e "${NC}"

# 1. Verify Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}[ERROR] Docker is not running. Please start Docker Desktop or the Docker daemon first.${NC}"
    exit 1
fi

# 2. Export Host UID/GID for container permissions
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"
export HOST_UID HOST_GID
export UID 2>/dev/null || true

# 3. Check for .env file
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo -e "${YELLOW}[WARN] .env not found. Creating .env from .env.example...${NC}"
        cp .env.example .env
    else
        echo -e "${RED}[ERROR] .env file is missing and no .env.example found!${NC}"
        exit 1
    fi
fi

# Load port variables from .env if present
APP_PORT=$(grep -E '^APP_PORT=' .env | cut -d '=' -f2 | tr -d ' "' || true)
APP_PORT=${APP_PORT:-8080}

DB_PORT=$(grep -E '^FORWARD_DB_PORT=' .env | cut -d '=' -f2 | tr -d ' "' || true)
DB_PORT=${DB_PORT:-33066}

REVERB_PORT=$(grep -E '^REVERB_PORT=' .env | cut -d '=' -f2 | tr -d ' "' || true)
REVERB_PORT=${REVERB_PORT:-8081}

# 4. Parse script flags (e.g. --build, -b)
BUILD_FLAG=""
for arg in "$@"; do
    case $arg in
        -b|--build)
            BUILD_FLAG="--build"
            shift
            ;;
    esac
done

# 5. Start containers
echo -e "${BLUE}▶ Bringing up Docker Compose services ${BUILD_FLAG}...${NC}"
docker compose up -d $BUILD_FLAG "$@"

# 6. Wait for services to be healthy
echo -e "${BLUE}▶ Waiting for database and application containers to be ready...${NC}"
RETRIES=30
while [ $RETRIES -gt 0 ]; do
    DB_STATUS=$(docker inspect --format='{{json .State.Health.Status}}' otp2025_db 2>/dev/null | tr -d '"' || true)
    if [ "$DB_STATUS" = "healthy" ]; then
        break
    fi
    sleep 1
    RETRIES=$((RETRIES - 1))
done

if [ "$DB_STATUS" != "healthy" ]; then
    echo -e "${YELLOW}[WARN] Database container healthcheck timed out. Services are still starting.${NC}"
else
    echo -e "${GREEN}✓ Database is healthy and ready.${NC}"
fi

# 7. Check if APP_KEY is generated
if ! grep -q "^APP_KEY=base64:" .env; then
    echo -e "${BLUE}▶ Generating application key...${NC}"
    docker compose exec -T app php artisan key:generate
fi

# 8. Ensure storage and bootstrap/cache permissions
docker compose exec -T -u root app chown -R www-data:www-data /var/www/html/storage/framework /var/www/html/storage/logs /var/www/html/bootstrap/cache >/dev/null 2>&1 || true
docker compose exec -T -u root app chmod -R 775 /var/www/html/storage/framework /var/www/html/storage/logs /var/www/html/bootstrap/cache >/dev/null 2>&1 || true

# 9. Summary & Quicklinks
echo ""
echo -e "${GREEN}${BOLD}✓ Application Stack is successfully running!${NC}"
echo "----------------------------------------------------------"
echo -e " 🌐 ${BOLD}Web Application:${NC}  http://localhost:${APP_PORT}"
echo -e " 📡 ${BOLD}Reverb Websocket:${NC} ws://localhost:${REVERB_PORT}"
echo -e " 🗄️  ${BOLD}MySQL Database:${NC}   localhost:${DB_PORT} (User: root, Pass: root)"
echo "----------------------------------------------------------"
echo -e "${CYAN}Helpful commands:${NC}"
echo -e "  • Stop app:        ${BOLD}./stop.sh${NC}"
echo -e "  • Restart app:     ${BOLD}./restart.sh${NC}"
echo -e "  • Run Artisan:     ${BOLD}./app.sh artisan <command>${NC}"
echo -e "  • Run Tests:       ${BOLD}./app.sh test${NC}"
echo -e "  • Open Shell:      ${BOLD}./app.sh shell${NC}"
echo "=========================================================="
echo ""
