defmodule Web.NgController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content(
      MainLayout.wrap([
        script(src: "https://ajax.googleapis.com/ajax/libs/angularjs/1.8.2/angular.min.js"),
        control()
      ])
    )
  end

  def control() do
    div(
      'ng-app': nil,
      html: [
        input(
          'ng-model': "yourName"
        ),
        span("{{ yourName}}")
      ]
    )

  end
end
