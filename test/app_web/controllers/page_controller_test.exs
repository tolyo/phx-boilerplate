defmodule Web.HomeControllerTest do
  use Web.ConnCase

  # Ensure routing initialization
  test "GET /", %{conn: conn} do
    # wnen: at root
    conn = get(conn, "/")

    # then: expect ui-view tag to be present
    assert html_response(conn, 200) =~ "ui-view"
  end
end
