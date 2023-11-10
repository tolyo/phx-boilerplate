defmodule MainApplication do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      {Postgrex,
       [
         name: :db,
         hostname: "localhost",
         database: "db",
         username: "postgres",
         password: "postgres"
       ]},
      # Start the Telemetry supervisor
      Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PubSub},
      # Start the Endpoint (http/https)
      Web.Endpoint
      # Start a worker by calling: Worker.start_link(arg)
      # {Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Web.Endpoint.config_change(changed, removed)
    :ok
  end

  # Check if running in prod environment as Mix.env is not available in prod
  @spec prod :: boolean
  def prod() do
    Application.get_env(:server, :environment) == :prod
  end
end
