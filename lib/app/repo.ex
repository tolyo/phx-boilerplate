defmodule Repo do
  # TODO: retire
  use Ecto.Repo,
    otp_app: :app,
    adapter: Ecto.Adapters.Postgres
end
