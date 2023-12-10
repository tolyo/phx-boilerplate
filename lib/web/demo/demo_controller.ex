defmodule Web.DemoController do
  use Web, :controller
  plug :put_layout, html: {Web.LayoutView, :main_layout}

  def index(conn, _),
    do:
      conn
      |> MainLayout.content(
        main([
          div("#{__MODULE__}")
        ])
      )
end
