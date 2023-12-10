clean:
	@rm -rf _build
	@mix deps.clean --all

setup: 
	@mix deps.get
	@go install github.com/pressly/goose/v3/cmd/goose@latest

compile:
	@mix do deps.get, deps.compile

start: 
	@MIX_ENV=dev iex -S mix phx.server

lint:
	@echo $(INFO) "Formatting Elixir"
	@mix format

check: 
	@echo $(INFO) "Typechecking Elixir"
	@mix compile
	@mix dialyzer --format dialyzer

function-test:
	@MIX_ENV=test mix phx.server