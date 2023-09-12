default: help

#❓ help: @ Displays all commands and tooling
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

setup:
	npm i

compile:
	mix do deps.get, deps.compile

# Helper for running dev mode
run-dev:
	MIX_ENV=dev iex -S mix phx.server

db-update:
	MIX_ENV=dev mix ecto.migrate
	MIX_ENV=test mix ecto.migrate

db-downgrade:
	MIX_ENV=dev mix ecto.rollback --all
	MIX_ENV=test mix ecto.rollback --all

# Helper for executing a hard reset on the database
db-rebuild: db-downgrade db-update

lint:
	mix format mix.exs 'lib/**/*.{ex,exs}' 'test/**/*.{ex,exs}'

check:
	mix dialyzer --format dialyzer

run-test:
	MIX_ENV=test mix test test/ lib/

run-quality-check: lint check run-test
