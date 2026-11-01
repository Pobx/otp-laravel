.PHONY: up down build ps sh logs test stan migrate seed fresh

up:
	docker compose up -d

down:
	docker compose down

build:
	docker compose build

ps:
	docker compose ps

sh:
	docker compose exec app bash

logs:
	docker compose logs -f

test:
	docker compose exec app php artisan test

stan:
	docker compose exec app vendor/bin/phpstan analyse --memory-limit=1G

migrate:
	docker compose exec app php artisan migrate

seed:
	docker compose exec app php artisan db:seed

fresh:
	docker compose exec app php artisan migrate:fresh --seed
