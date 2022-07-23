defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      Nitroux.Utils.tag("server-page", %{}, false)
      |> MainLayout.wrap()
    )
  end

  def test(conn, _params) do
    conn
    |> content(section(%{
      html: [
        h1("PHX Boilerplate"),
        div("a starter template for scalable development")
      ]
    }))
  end
end
