defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      p("Hello world")
      |> MainLayout.wrap()
    )
  end
end
