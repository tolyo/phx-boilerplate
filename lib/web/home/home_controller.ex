defmodule Web.HomeController do
  use Web, :controller
  plug :put_layout, "main_layout.html"

  def index(conn, _params) do
    conn
    |> MainLayout.content([
      Nitroux.Utils.tag("ui-view", id: "root", class: "container")
    ])
  end

  def home(conn, _params) do
    conn
    |> content([
      div(
        id: "home",
        html: [
          h1("Phoenix Framework Boilerplate"),
          div("A starter template for scalable development")
        ]
      )
    ])
  end
end
