defmodule Web.AjaxtestController do
  use Web, :controller

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _) do
    conn
    |> put_layout(html: {Web.LayoutView, :main_layout})
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
  end

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
