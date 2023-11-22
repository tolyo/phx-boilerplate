# Frontend management make
default: help

# Frontend make file context
FRONTEND_CONTEXT = make -f lib/web/frontend.mk
SERVER_CONTEXT = make -f server.mk

INFO = "\033[32m[INFO]\033[0m"

#❓ help: @ Displays all commands and tooling
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	@echo $(INFO) "Cleaning project..."
	$(FRONTEND_CONTEXT) clean
	$(c) clean
	@echo $(INFO) "Complete. Run 'make setup' to install dependencies"

setup:
	$(FRONTEND_CONTEXT) setup
	@echo $(INFO) "Installing MIX dependencies..."
	$(SERVER_CONTEXT) setup
	@echo $(INFO) "Complete. Run 'make start' to start server"
	
compile:
	$(SERVER_CONTEXT) compile

# Helper for running dev mode
start:
	@make db-up
	$(FRONTEND_CONTEXT) start &
	$(SERVER_CONTEXT) start
	pkill -P $$

include ./config/dev.env
DBDSN:="host=$(POSTGRES_HOST) user=$(POSTGRES_USER) password=$(POSTGRES_PASSWORD) dbname=$(POSTGRES_DB) port=$(POSTGRES_PORT) sslmode=disable"
MIGRATE_OPTIONS=-allow-missing -dir="./sql"

db-up: ## Migrate down on database
	@go install github.com/pressly/goose/v3/cmd/goose@latest
	@goose -v $(MIGRATE_OPTIONS) postgres $(DBDSN) up

db-down: ## Migrate up on database
	@goose -v $(MIGRATE_OPTIONS) postgres $(DBDSN) reset

# # Helper for executing a hard reset on the database
db-rebuild:
	@make db-down
	@make db-up

lint:
	$(FRONTEND_CONTEXT) lint
	$(SERVER_CONTEXT) lint
	@echo $(INFO) "Complete"

check:
	$(FRONTEND_CONTEXT) check
	$(SERVER_CONTEXT) check

.PHONY: test
test:
	MIX_ENV=test mix test test/ lib/

functional-test:
	$(SERVER_CONTEXT) functional-test &
	$(FRONTEND_CONTEXT) test
	@kill -9 $$(lsof -t -i :4000) # todo: remove port

quality:
	@make lint
	@make check
	@make test
