defmodule Web.HelloController do
  use Web, :controller
  plug :put_layout, false

  def index(conn, _params) do
    conn
    |> html("sample html")
  end

  def greet(conn, _params) do
    conn
    |> render(
      "hello.html",
      greeting: "Hello world"
    )
  end

  def goodbye(conn, _params) do
    conn
    |> render("goodbye.html")
  end

  def greet_nitro(conn, _params) do
    conn
    |> content(h1("Hello world"))
  end
end
