defmodule MainLayout do
  import Nitroux
  use Web, :controller

  @doc """
  Optional wrapper helper. Default to content/2 as it allows to use layout plugs
  """
  @spec wrap(String.t()) :: String.t()
  def wrap(content) do
    "<!DOCTYPE html>" <>
      Nitroux.html(
        lang: Gettext.get_locale(Web.Gettext),
        translate: "no",
        html: [
          LayoutHelper.header(),
          content |> body(),
          LayoutHelper.footer()
        ]
      )
  end

  @spec content(Plug.Conn.t(), any) :: Plug.Conn.t()
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

  @spec header() :: String.t()
  def header() do
    header(nav(a(href: "/", html: strong("PHX"))))
  end
end
