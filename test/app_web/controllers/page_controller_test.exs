defmodule Web.PageControllerTest do
  use Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) != nil
  end
end
