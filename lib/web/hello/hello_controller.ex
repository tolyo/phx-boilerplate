defmodule Web.HelloController do
  use Web, :controller
  plug :put_layout, html: {Web.LayoutView, :main_layout}

  @moduledoc """
  This example showcases the use of Nitroux tags with standard .eex templates.
  Standard Phoenix views are always available as a fallback
  """

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _), do: conn |> html("sample html")

  @spec greet(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def greet(conn, _),
    do:
      conn
      |> render(
        "hello.html",
        greeting: "Hello world"
      )

  @spec goodbye(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def goodbye(conn, _), do: conn |> render("goodbye.html")

  @spec greet_nitro(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def greet_nitro(conn, _), do: conn |> content(h1("Hello Nitroux"))

  @spec time(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def time(conn, _), do: conn |> content(div("#{DateTime.utc_now() |> DateTime.to_time()}"))

  @spec typography(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def typography(conn, _), do: conn |> render("typography.html")
end
