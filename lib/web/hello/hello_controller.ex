defmodule Web.HelloController do
  use Web, :controller
  plug :put_layout, "main_layout"

  @moduledoc """
  This example showcases the use of Nitroux tags with standard .eex templates.
  Standard Phoenix views are always available as a fallback
  """

  def index(conn, _), do: conn |> html("sample html")

  def greet(conn, _),
    do:
      conn
      |> render(
        "hello.html",
        greeting: "Hello world"
      )

  def goodbye(conn, _), do: conn |> render("goodbye.html")
  def greet_nitro(conn, _), do: conn |> content(h1("Hello Nitroux"))
end
