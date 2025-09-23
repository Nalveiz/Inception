COMPOSE = docker compose -f srcs/docker-compose.yml
DATA_PATH = $(HOME)/data

all: build up

build:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress
	@$(COMPOSE) build

up:
	@echo "Starting containers..."
	@$(COMPOSE) up -d

down:
	@echo "Stopping containers..."
	@$(COMPOSE) down

clean: down
	@echo "Cleaning Docker system..."
	@sudo docker system prune -af
	@sudo docker volume prune -f

fclean: clean
	@echo "Removing all host data..."
	@sudo rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress || true

purge:
	@echo "🚨 Purging ALL Docker containers, volumes, networks, and images..."
	@docker rm -f $$(docker ps -aq) 2>/dev/null || true
	@docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@docker rmi -f $$(docker images -q) 2>/dev/null || true
	@echo "✅ Docker environment fully cleaned!"


re: fclean all

.PHONY: all build up down clean fclean  purge re
