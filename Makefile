# Frontend management make
include lib/web/Makefile

default: help

# Frontend make file context
FRONTEND_CONTEXT = make -C lib/web frontend

INFO = "\033[32m[INFO]\033[0m"

#❓ help: @ Displays all commands and tooling
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	@echo $(INFO) "Cleaning project..."
	$(FRONTEND_CONTEXT).clean
	@rm -rf _build
	@rm mix.lock
	@echo $(INFO) "Complete. Run 'make setup' to install dependencies"

setup:
	$(FRONTEND_CONTEXT).setup
	@echo $(INFO) "Installing MIX dependencies..."
	@mix deps.get
	@echo $(INFO) "Complete. Run 'make start' to start server"
	@go install github.com/pressly/goose/v3/cmd/goose@latest
	

compile:
	@mix do deps.get, deps.compile

# Helper for running dev mode
start:
	$(FRONTEND_CONTEXT).start &
	MIX_ENV=dev iex -S mix phx.server
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
	$(FRONTEND_CONTEXT).lint
	@echo $(INFO) "Formatting Elixir"
	@mix format
	@echo $(INFO) "Complete"

check:
	$(FRONTEND_CONTEXT).check
	@echo $(INFO) "Typechecking Elixir"
	@mix compile
# TODO: @mix dialyzer --format dialyzer

.PHONY: test
test:
	MIX_ENV=test mix test test/ lib/

functional-test:
	@MIX_ENV=test mix phx.server &
	$(FRONTEND_CONTEXT).test
	@kill -9 $$(lsof -t -i :4000) # todo: remove port

quality:
	@make lint
	@make check
	@make test
