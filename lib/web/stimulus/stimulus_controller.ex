defmodule Web.StimulusController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      MainLayout.wrap(
        div(
          'data-controller': "example",
          html: [
            input(
              'data-example-target': "name",
              'data-action': "input->example#greet"
            ),
            span(
              'data-example-target': "output"
            )
          ]
        )
      )
    )
  end

end
