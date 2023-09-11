defmodule Web.AlpineController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      MainLayout.wrap([
        script(src: "//unpkg.com/alpinejs", defer: nil),
        control()
      ])
    )
  end

  def control() do
    div(
      "x-data": "{ count: 0 }",
      html: [
        button(
          "x-on:click": "count++",
          html: "Increment"
        ),
        span("x-text": "count")
      ]
    )
    |> div()
  end
end
