defmodule Web.HtmxController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      MainLayout.wrap([
        script(src: "https://unpkg.com/htmx.org@1.9.5"),
        control()
      ])
    )
  end

  def hello(conn, _params) do
    conn
    |> content([
      div("Current time: #{DateTime.utc_now() |> DateTime.to_time()}")
    ])
  end

  def control() do
    [
      div(id: "res", html: "Current time: "),
      button(
        "hx-get": "/htmx/hello",
        "hx-target": "#res",
        "hx-swap": "innerHTML",
        html: "Current time"
      )
    ]
    |> div()
  end
end
