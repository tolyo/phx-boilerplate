defmodule Web.DocsController do
  use Web, :controller
  plug :put_layout, {Web.LayoutView, "main_layout.html"}

  def index(conn, _),
    do:
      conn
      |> MainLayout.content(
        main([
          div("#{__MODULE__}")
        ])
      )
end
