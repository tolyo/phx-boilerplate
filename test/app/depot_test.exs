defmodule DepotTest do
  use DataCase

  alias Depot

  describe "products" do
    alias Depot.Product

    import DepotFixtures

    @invalid_attrs %{title: nil, image_url: nil, price: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Depot.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Depot.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{title: "some title", image_url: "some image_url", price: "120.5"}

      assert {:ok, %Product{} = product} = Depot.create_product(valid_attrs)
      assert product.title == "some title"
      assert product.image_url == "some image_url"
      assert product.price == Decimal.new("120.5")
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Depot.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        title: "some updated title",
        image_url: "some updated image_url",
        price: "456.7"
      }

      assert {:ok, %Product{} = product} = Depot.update_product(product, update_attrs)
      assert product.title == "some updated title"
      assert product.image_url == "some updated image_url"
      assert product.price == Decimal.new("456.7")
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Depot.update_product(product, @invalid_attrs)
      assert product == Depot.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Depot.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Depot.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Depot.change_product(product)
    end
  end
end
