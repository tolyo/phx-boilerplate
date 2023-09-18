defmodule Web.HomeController do
  use Web, :controller
  plug :put_layout, "main_layout.html"

  def index(conn, _params) do
    conn
    |> MainLayout.content([
      script(src: "//unpkg.com/alpinejs", defer: nil),
      header(),
      Nitroux.Utils.tag("ui-view", id: "root")
    ])
  end

  def home(conn, _params) do
    conn
    |> content([
      div([
        h1("Phoenix Framework Boilerplate"),
        div("A starter template for scalable development"),
        div(
          "x-data": "{ count: 1 }",
          html: [
            button(
              "x-on:click": "count++",
              html: "Increment"
            ),
            span("x-text": "count")
          ]
        )
        |> div()
      ])
    ])
  end

  def header do
    section([
      a(id: "logo", href: "/", html: "PHX Boilerplate"),
      nav([
        a(onclick: "router.stateService.go('products')", html: "products")
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
