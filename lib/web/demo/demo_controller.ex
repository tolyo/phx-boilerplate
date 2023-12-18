defmodule Web.DemoController do
  use Web, :controller
  plug :put_layout, html: {Web.LayoutView, :main_layout}

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _),
    do:
      conn
      |> MainLayout.content(
        main([
          div("#{__MODULE__}")
        ])
      )
end
