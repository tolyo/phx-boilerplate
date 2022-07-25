defmodule Web.HomeController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(MainLayout.wrap([header(), span(%{id: "outlet"})]))
  end

  def home(conn, _params) do
    conn
    |> content([
      div([
        h1("PHX Boilerplate"),
        div("a starter template for scalable development"),
        h6("Made in Latvia")
      ])
    ])
  end

  def header do
    section([
      a(id: "logo", href: "/", html: "Logo"),
      nav([
        a(href: "/login", html: "Login"),
        a(href: "/register", html: "Register")
      ])
    ])
  end

  def login(conn, _params) do
    conn
    |> content([
      "Login"
    ])
  end

  def register(conn, _params) do
    conn
    |> content([
      "Register"
    ])
  end
end
