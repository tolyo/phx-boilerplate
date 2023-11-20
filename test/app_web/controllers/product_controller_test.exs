defmodule Web.ProductControllerTest do
  use Web.ConnCase

  import ProductFixtures

  @create_attrs %{
    title: "some title",
    image_url: "some image_url",
    price: "100",
    amount: "10"
  }

  @update_attrs %{
    title: "some updated title",
    image_url: "some updated image_url",
    price: "200",
    amount: "10"
  }

  @invalid_attrs %{title: nil, image_url: nil, price: nil, amount: nil}

  describe "index" do
    test "lists all products", %{conn: conn} do
      # when
      conn = get(conn, "/_products")

      # then
      assert html_response(conn, 200) =~ "List products"
      assert html_response(conn, 200) =~ "table"
    end
  end

  describe "new product" do
    test "renders form", %{conn: conn} do
      # when
      conn = get(conn, "/_products/new")

      # when
      assert html_response(conn, 200) =~ "New product"
      assert html_response(conn, 200) =~ "form"
    end
  end

  describe "create product" do
    test "returns 201 to show when data is valid", %{conn: conn} do
      # when
      conn = post(conn, "/products", @create_attrs)

      # then
      assert %{"id" => id} = json_response(conn, 201)

      # when
      conn = get(conn, "/_products/#{id}")

      # then
      assert html_response(conn, 200) =~ "id"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # when
      conn = post(conn, "/products", @invalid_attrs)

      # then
      assert json_response(conn, 422) != nil
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, id: id} do
      # when
      conn = get(conn, "/_products/edit/#{id}")

      # then
      assert html_response(conn, 200) =~ "Edit"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "204 when data is valid", %{conn: conn, id: id} do
      # when
      conn = post(conn, "/products/#{id}", @update_attrs)

      # then
      assert response(conn, 204)

      # when
      conn = get(conn, "/_products/#{id}")

      # then
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, id: id} do
      # when
      conn = post(conn, "/products/#{id}", @invalid_attrs)

      # then
      assert json_response(conn, 422)
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, id: id} do
      # when
      conn = post(conn, "/products/delete/", %{id: "#{id}"})
      conn = get(conn, "/_products/#{id}")

      # then
      # TODO this should return 404
      assert response(conn, 200) =~ "not found"
    end
  end

  defp create_product(_) do
    id = product_fixture()
    %{id: id}
  end
end
