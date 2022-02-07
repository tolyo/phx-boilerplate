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
