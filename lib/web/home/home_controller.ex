defmodule Web.HomeController do
  use Web, :controller
  import Components

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> put_layout(html: {Web.LayoutView, :main_layout})
    |> MainLayout.content([
      Nitroux.Utils.tag("ui-view", id: "root")
    ])
  end

  @spec home(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def home(conn, _params) do
    conn
    |> content([
      div(
        id: "home",
        html: [
          main([
            h1("Phoenix Framework Boilerplate"),
            div("A starter template"),
            partial(get_path(__MODULE__, :subview), "test"),
            section([
              a(href: get_path(Web.DemoController, :index), html: "Demo"),
              a(href: get_path(Web.DocsController, :index), html: "Docs"),
              a(href: get_path(Web.MobileController, :index), html: "Mobile")
            ])
          ])
        ]
      )
    ])
  end

  @spec subview(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def subview(conn, _) do
    conn
    |> content([
      div("for scalable development")
    ])
  end

  @spec subview2(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def subview2(conn, _) do
    conn
    |> content([
      div("for fast development")
    ])
  end
end
