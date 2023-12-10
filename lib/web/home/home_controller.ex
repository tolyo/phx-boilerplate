defmodule Web.HomeController do
  use Web, :controller
  import Components
  plug :put_layout, {Web.LayoutView, "main_layout.html"}

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> MainLayout.content([
      Nitroux.Utils.tag("ui-view", id: "root")
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
          partial(get_path(__MODULE__, :subview), "test"),
          section([
            a(href: get_path(Web.DemoController, :index), html: "Demo"),
            a(href: get_path(Web.DocsController, :index), html: "Docs")
          ])
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
