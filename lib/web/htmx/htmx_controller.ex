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
      div("#{DateTime.utc_now()|> DateTime.to_time }"),
    ])
  end

  def control() do
    button(
      'hx-get': "/htmx/hello",
      'hx-swap': "afterend",
      html: "Current time"
    ) |> div()
  end
end
