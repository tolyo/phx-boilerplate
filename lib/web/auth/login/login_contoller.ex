defmodule Web.LoginController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> content([
      h2("Login"),
      button(
        onclick: "window.alert('You clicked me')",
        html: "Click me"
      )
    ])
  end
end
