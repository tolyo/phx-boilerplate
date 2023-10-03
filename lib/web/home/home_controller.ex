defmodule Web.HomeController do
  use Web, :controller
  import Components
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
          div("A starter template"),
          partial(get_path(__MODULE__, :subview))
        ]
      )
    ])
  end

  def subview(conn, _) do
    conn
    |> content([
      div("for scalable development")
    ])
  end

  def subview2(conn, _) do
    conn
    |> content([
      div("for fast development")
    ])
  end
end
