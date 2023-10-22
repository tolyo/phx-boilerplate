defmodule Web.AjaxtestController do
  use Web, :controller
  plug :put_layout, "main_layout.html"

  def index(conn, _),
    do:
      conn
      |> MainLayout.content(
        main([
          form(
            "data-action": get_path(__MODULE__, :calculate),
            "data-update": "#myDiv",
            html: [
              h4("Calculator"),
              label(input(name: "value1", type: "integer", value: 0)),
              label(input(name: "value2", type: "integer", value: 0)),
              Forms.csrf_input(),
              button("Add")
            ]
          ),
          div(id: "myDiv")
        ])
      )

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
    |> content(p("Result: #{x + y}"))
  end
end
