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
	@docker system prune -af
	@docker volume prune -f

fclean: clean
	@echo "Removing all host data..."
	@rm -rf $(DATA_PATH)/mariadb $(DATA_PATH)/wordpress || true

re: fclean all

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

.PHONY: all build up down clean fclean re logs ps
