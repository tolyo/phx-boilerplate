defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(MainLayout.wrap(server_page("test")))
  end

  def test(conn, _params) do
    conn
    |> content(
      section([
        h1("PHX Boilerplate"),
        div("a starter template for scalable development"),
        h6("Made in Latvia")
      ])
    )
  end
end
