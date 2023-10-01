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

compile:
	@mix do deps.get, deps.compile

# Helper for running dev mode
start:
	MIX_ENV=dev iex -S mix phx.server

db-update:
	MIX_ENV=dev mix ecto.migrate
	MIX_ENV=test mix ecto.migrate

db-downgrade:
	MIX_ENV=dev mix ecto.rollback --all
	MIX_ENV=test mix ecto.rollback --all

# Helper for executing a hard reset on the database
db-rebuild:
	@make db-downgrade
	@make db-update

lint:
	$(FRONTEND_CONTEXT).lint
	@echo $(INFO) "Formatting Elixir"
	@mix format
	@echo $(INFO) "Complete"

check:
	$(FRONTEND_CONTEXT).check
	# @echo $(INFO) "Typechecking Elixir"
	# @mix dialyzer --format dialyzer

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
