defmodule MainLayout do
  import Nitroux
  use Web, :controller

  @doc """
  Optional wrapper helper. Default to content/2 as it allows to use layout plugs
  """
  def wrap(content) do
    "<!DOCTYPE html>" <>
      html(
        lang: Gettext.get_locale(Web.Gettext),
        translate: "no",
        html: [
          LayoutHelper.header(),
          content |> body(),
          LayoutHelper.footer()
        ]
      )
  end

  @spec content(any, any) :: none
  def content(conn, data) do
    conn
    |> put_view(Web.LayoutView)
    |> render(
      "app.html",
      content: [
        header(),
        data
      ]
    )
  end

  def header() do
    header(nav(a(href: "/", html: strong("PHX"))))
  end
end
