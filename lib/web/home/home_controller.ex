defmodule Web.HomeController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(MainLayout.wrap([header(), span(id: "outlet")]))
  end

  def home(conn, _params) do
    conn
    |> content([
      div([
        h1("Phoenix Framework Boilerplate"),
        div("A starter template for scalable development")
      ])
    ])
  end

  def header do
    section([
      a(id: "logo", href: "/", html: "PHX Boilerplate"),
      nav([
        a(href: "/login", html: "Login")
      ])
    ])
  end

  def login(conn, _params) do
    conn
    |> content("Login")
  end

  def register(conn, _params) do
    conn
    |> content([
      "Register"
    ])
  end
end
