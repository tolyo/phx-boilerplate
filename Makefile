

default: help

INFO = "\033[32m[INFO]\033[0m"

#❓ help: @ Displays all commands and tooling
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

clean:
	@echo $(INFO) "Cleaning project..."
	@rm -rf node_modules
	@rm -rf deps
	@rm -rf _build
	@rm package-lock.json
	@rm mix.lock
	@echo $(INFO) "Complete. Run 'make setup' to install dependencies"

setup:
	@echo $(INFO) "Installing NPM dependencies..."
	@npm i
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
	@echo $(INFO) "Formatting Js/CSS"
	@npm run format
	@echo $(INFO) "Linting Js"
	@npm run lint
	@echo $(INFO) "Formatting Elixir"
	@mix format mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}'
	@echo $(INFO) "Complete"

check:
	@echo $(INFO) "Typechecking Js"
	@npm run typecheck
	@echo $(INFO) "Typechecking Elixit"
	@mix dialyzer --format dialyzer

run-test:
	MIX_ENV=test mix test test/ lib/

run-quality-check:
	@make lint
	@make check
	@make run-test
