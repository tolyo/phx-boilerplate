defmodule Web.LoginController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content([
      "Login"
    ])
  end
end
