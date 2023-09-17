defmodule MainLayout do
  use Web, :controller

  def content(conn, data) do
    conn
    |> put_view(Web.LayoutView)
    |> render(
      "app.html",
      content: data
    )
  end
end
