#!/usr/bin/env bash

# ==============================================================================
# Script: app.sh
# Description: All-in-one CLI helper for OTP 2025 Docker environment
# ==============================================================================

set -e

cd "$(dirname "$0")"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

HOST_UID="$(id -u)"
HOST_GID="$(id -g)"
export HOST_UID HOST_GID
export UID 2>/dev/null || true

show_help() {
    echo -e "${CYAN}${BOLD}OTP 2025 Docker Management CLI${NC}"
    echo "Usage: ./app.sh <command> [arguments]"
    echo ""
    echo -e "${BOLD}Lifecycle Commands:${NC}"
    echo "  start | up           Start all services in background (./start.sh)"
    echo "  stop  | down         Stop all services (./stop.sh)"
    echo "  restart              Restart all services (./restart.sh)"
    echo "  status | ps          View status of all containers"
    echo "  logs [service]       Tail logs for all services or a specific service"
    echo ""
    echo -e "${BOLD}Development & Tools:${NC}"
    echo "  artisan <cmd>        Run PHP Artisan commands inside the app container"
    echo "  composer <cmd>       Run Composer commands inside the app container"
    echo "  test [filter]        Run PHPUnit / Pest test suite"
    echo "  pint [options]       Run Laravel Pint code style fixer / linter"
    echo "  phpstan [options]    Run PHPStan static analysis"
    echo ""
    echo -e "${BOLD}Database & Cache:${NC}"
    echo "  migrate [options]    Run database migrations"
    echo "  seed [options]       Run database seeders"
    echo "  mysql                Open interactive MySQL CLI session in database"
    echo "  redis                Open interactive Redis CLI session"
    echo "  cache-clear          Clear all application caches (config, route, view)"
    echo ""
    echo -e "${BOLD}Shell Access:${NC}"
    echo "  shell | bash         Open a bash shell inside 'app' as www-data"
    echo "  root-shell           Open a bash shell inside 'app' as root"
    echo ""
}

COMMAND="$1"
shift || true

case "$COMMAND" in
    start|up)
        ./start.sh "$@"
        ;;
    stop|down)
        ./stop.sh "$@"
        ;;
    restart)
        ./restart.sh "$@"
        ;;
    status|ps)
        docker compose ps
        ;;
    logs)
        docker compose logs -f "$@"
        ;;
    artisan)
        docker compose exec app php artisan "$@"
        ;;
    composer)
        docker compose exec app composer "$@"
        ;;
    test)
        docker compose exec app php artisan test "$@"
        ;;
    pint)
        docker compose exec app vendor/bin/pint "$@"
        ;;
    phpstan)
        docker compose exec app vendor/bin/phpstan analyse --memory-limit=1G "$@"
        ;;
    migrate)
        docker compose exec app php artisan migrate "$@"
        ;;
    seed)
        docker compose exec app php artisan db:seed "$@"
        ;;
    mysql)
        docker compose exec db mysql -u root -proot envsogo_main "$@"
        ;;
    redis)
        docker compose exec redis redis-cli "$@"
        ;;
    cache-clear)
        docker compose exec app php artisan optimize:clear
        ;;
    shell|bash)
        docker compose exec app bash
        ;;
    root-shell)
        docker compose exec -u root app bash
        ;;
    help|--help|-h|"")
        show_help
        ;;
    *)
        echo -e "${YELLOW}Unknown command: $COMMAND${NC}"
        echo ""
        show_help
        exit 1
        ;;
esac
