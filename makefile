IMAGE_NAME := $(shell grep 'name:' Jenkinsfile | sed "s/.\+'\(.\+\)'.\+/\1/g")
CONTAINER_CMD := docker
COMPOSE_FILES := -f docker-compose.yml

ifneq (,$(wildcard docker-compose.ssh.yml))
	COMPOSE_FILES += -f docker-compose.ssh.yml
endif

default:
	@echo "Usage:"
	@echo "  make build"
	@echo
	@echo "    Builds the $(IMAGE_NAME) image for local use."
	@echo
	@echo "  make start"
	@echo
	@echo "    Starts the compose stack for this plugin in the background."
	@echo
	@echo "  make stop"
	@echo
	@echo "    Shuts down a running compose stack for this plugin."
	@echo
	@echo "  make destroy"
	@echo
	@echo "    Shuts down and purges state for the compose stack for this plugin."
	@echo
	@echo "  make logs"
	@echo
	@echo "    Binds the current console to the log output docker stack."
	@echo
	@echo '    Equivalent to `tail -f $$LOG_FILE_PATH`'
	@echo
	@echo "  make shell-cmd"
	@echo
	@echo "    Echos a command to open a bash session in a running instance of this"
	@echo "    project's $(IMAGE_NAME) image."
	@echo
	@echo '    Intended to be used with eval:'
	@echo '        $$ eval `make shell-cmd`'

build:
	@$(CONTAINER_CMD) compose build

start: .env
	@mkdir -p mount/$$(grep 'SITE_BUILD=' .env | cut -d= -f2)
	@$(CONTAINER_CMD) compose $(COMPOSE_FILES) up -d;

stop: .env
	@$(CONTAINER_CMD) compose $(COMPOSE_FILES) stop

destroy: .env
	@$(CONTAINER_CMD) compose $(COMPOSE_FILES) down -v --remove-orphans

shell-cmd:
	@echo $(CONTAINER_CMD) exec -it $${PWD##*/}-plugin-1 bash

logs: .env
	@$(CONTAINER_CMD) compose $(COMPOSE_FILES) logs -f


# TESTS

.env:
	@echo >&2
	@echo ".env file must be configured before running the stack." >&2
	@echo >&2
	@exit 1