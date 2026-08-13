UID := $(shell id -u)
GID := $(shell id -g)

export UID
export GID

MAKEFLAGS += --warn-undefined-variables
PREFIX_CMD ?=
ENV_FILE ?= docker/.env
DOCKER_COMPOSE := $(PREFIX_CMD) docker compose --env-file $(ENV_FILE)
DOCKER_COMPOSE_BASE := $(PREFIX_CMD) docker compose -f docker-compose.base.yml
STACK_NAME := vestalis_photo

export PUID ?= $(shell id -u)
export PGID ?= $(shell id -g)

APP_BUILD_VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0")
APP_BUILD_VERSION := $(APP_BUILD_VERSION).dev
export APP_BUILD_VERSION

################################################################
## DEPLOYMENT
################################################################
rebuild: stop build start
.PHONY: rebuild

update-version: rebuild
.PHONY: update-version

################################################################
## ALL CONTAINERS
################################################################
build:
	$(DOCKER_COMPOSE) build --build-arg BUILDKIT_INLINE_CACHE=1
.PHONY: build

start:
	$(DOCKER_COMPOSE) up -d
.PHONY: start

restart:
	$(DOCKER_COMPOSE) restart
.PHONY: restart

stop:
	$(DOCKER_COMPOSE) stop
.PHONY: stop

down:
	$(DOCKER_COMPOSE) down
.PHONY: down

logs: ## Read the logs from docker compose (the entire stack), and follow them (like tail -f)
	$(DOCKER_COMPOSE) logs --follow
.PHONY: logs

################################################################
## SPECIFIC CONTAINER
################################################################
shell-specific: ## Run a shell inside the development application container
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make shell-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) run --rm $(CONTAINER) bash
.PHONY: shell-specific

attach-specific: ## Starts an interactive shell inside the "app" service via "exec command" and with your local user id
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make attach-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) exec -u $(PUID):$(PGID) $(CONTAINER) bash
.PHONY: attach-specific

attach-root-specific: ## Starts an interactive shell inside the "app" service via "exec command" as root
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make attach-root-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) exec $(CONTAINER) bash
.PHONY: attach-root-specific

build-specific:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make build-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) build $(CONTAINER) --build-arg BUILDKIT_INLINE_CACHE=1
.PHONY: build-specific

start-specific:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make start-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) up -d $(CONTAINER)
.PHONY: start-specific

restart-specific:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make restart-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) restart $(CONTAINER)
.PHONY: restart-specific

stop-specific:
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make stop-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) stop $(CONTAINER)
.PHONY: stop-specific

logs-specific: ## Read the logs from docker compose (specific container), and follow them (like tail -f)
	@if [ -z "$(CONTAINER)" ]; then \
		echo "Usage: make logs-specific CONTAINER=<service>"; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) logs $(CONTAINER) --follow
.PHONY: logs-specific

################################################################
## FRONTEND
################################################################
shell-frontend: CONTAINER=frontend
shell-frontend: shell-specific
.PHONY: shell-frontend

attach-frontend: CONTAINER=frontend
attach-frontend: attach-specific
.PHONY: attach-frontend

attach-root-frontend: CONTAINER=frontend
attach-root-frontend: attach-root-specific
.PHONY: attach-root-frontend

build-frontend: CONTAINER=frontend
build-frontend: build-specific
.PHONY: build-frontend

start-frontend: CONTAINER=frontend
start-frontend: start-specific
.PHONY: start-frontend

restart-frontend: CONTAINER=frontend
restart-frontend: restart-specific
.PHONY: restart-frontend

stop-frontend: CONTAINER=frontend
stop-frontend: stop-specific
.PHONY: stop-frontend

logs-frontend: CONTAINER=frontend
logs-frontend: logs-specific
.PHONY: logs-frontend

################################################################
## BASE CONTAINERS
################################################################
start-base:
	$(DOCKER_COMPOSE_BASE) up -d --build
.PHONY: start-base

restart-base:
	$(DOCKER_COMPOSE_BASE) restart
.PHONY: restart-base

stop-base:
	$(DOCKER_COMPOSE_BASE) stop
.PHONY: stop-base

down-base:
	$(DOCKER_COMPOSE_BASE) stop
.PHONY: down-base

logs-base:
	$(DOCKER_COMPOSE_BASE) stop
.PHONY: logs-base

################################################################
## MISC
################################################################
help:
	@awk 'BEGIN{FS=":.*## "}/^[a-zA-Z0-9_.-]+:.*## /{printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
.PHONY: help