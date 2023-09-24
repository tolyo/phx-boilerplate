defmodule Web.ProductControllerTest do
  use Web.ConnCase

  import ProductFixtures

  @create_attrs %{"title" => "some title", "image_url" => "some image_url", "price" => "120.5"}
  @update_attrs %{
    title: "some updated title",
    image_url: "some updated image_url",
    price: "456.7"
  }
  @invalid_attrs %{title: nil, image_url: nil, price: nil}

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
      conn =
        post(conn, "/products", %{
          "title" => "some title",
          "image_url" => "some image_url",
          "price" => "120.5"
        })

      # then
      assert json_response(conn, 201)

      # conn = get(conn, "/products/#{id}")
      # assert html_response(conn, 200) =~ "Product #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, "/products", product: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Product"
    end
  end

  describe "edit product" do
    setup [:create_product]

    test "renders form for editing chosen product", %{conn: conn, product: product} do
      conn = get(conn, "/products/#{product}/edit")
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "update product" do
    setup [:create_product]

    test "redirects when data is valid", %{conn: conn, product: product} do
      conn = put(conn, "/products/#{product}", product: @update_attrs)
      assert redirected_to(conn) == "/products/#{product}"

      conn = get(conn, "/products/#{product}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn = put(conn, "/products/#{product}", product: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Product"
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = get(conn, "/products/delete#{product.id}")
      assert redirected_to(conn) == "/products"

      assert_error_sent 404, fn ->
        get(conn, "/products/#{product}")
      end
    end
  end

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
