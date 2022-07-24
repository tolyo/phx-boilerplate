defmodule Web.HomeController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(MainLayout.wrap(server_page("home")))
  end

  def home(conn, _params) do
    conn
    |> content([
      header(),
      div(
        [
          h1("PHX Boilerplate"),
          div("a starter template for scalable development"),
          h6("Made in Latvia")
        ]
      )
    ])
  end

  def header do
    section([
      span([id: "logo", html: "Logo"]),
      nav([
        a("Login"),
        a("Register")
      ])
    ])
  end
end
