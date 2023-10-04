defmodule Web.FormtestController do
  use Web, :controller
  plug :put_layout, "main_layout"

  def index(conn, _),
    do:
      conn
      |> render("form.html")

  def calculate(
        conn,
        %{
          "value1" => value1,
          "value2" => value2
        }
      ) do
    x = Integer.parse(value1) |> elem(0)
    y = Integer.parse(value2) |> elem(0)

    conn
    |> put_layout(false)
    |> content(p("Result: #{x + y}"))
  end
end
