defmodule ProductTest do
  use DataCase

  describe "products" do
    import ProductFixtures

    @invalid_attrs %{title: nil, image_url: nil, price: nil}

    test "list/0 returns all" do
      # when
      instance_id = product_fixture()

      # then
      assert DB.list("products") |> Enum.map(fn x -> x["id"] end) == [instance_id]
    end

    #   test "get/1 finds by id" do
    #     # given
    #     assert DB.get("products", 1) == nil

    #     # when
    #     instance = product_fixture()

    #     # then
    #     assert DB.get("products", instance["id"]) == instance
    #   end

    #   test "create/1 with valid data " do
    #     # when
    #     valid_attrs = %{title: "some title", image_url: "some image_url", price: "120.5"}

    #     # then
    #     assert {:ok, %Product{} = instance} = DB.create("products", valid_attrs)
    #     assert instance.id != nil
    #     assert instance.title == "some title"
    #     assert instance.image_url == "some image_url"
    #     assert instance.price == Decimal.new("120.5")
    #   end

    #   test "create/1 with invalid data" do
    #     # assert
    #     assert {:error, %Ecto.Changeset{}} = DB.create("products", @invalid_attrs)
    #   end

    #   test "update/2 with valid data" do
    #     # when
    #     product = product_fixture()

    #     update_attrs = %{
    #       title: "some updated title",
    #       image_url: "some updated image_url",
    #       price: "456.7"
    #     }

    #     # then
    #     assert {:ok, %Product{} = product} = Product.update(product, update_attrs)
    #     assert product.title == "some updated title"
    #     assert product.image_url == "some updated image_url"
    #     assert product.price == Decimal.new("456.7")
    #   end

    #   test "update/2 with invalid data" do
    #     # when
    #     product = product_fixture()

    #     # then
    #     assert {:error, %Ecto.Changeset{}} = Product.update(product, @invalid_attrs)
    #     assert product == Product.get(product.id)
    #   end

    #   test "delete/1" do
    #     # when
    #     product = product_fixture()

    #     # then
    #     assert {:ok, _} = Product.delete(product)
    #     assert Product.get(product.id) == nil
    #   end

    #   test "change/2 changeset" do
    #     # when
    #     product = product_fixture()

    #     # then
    #     assert %Ecto.Changeset{} = Product.changeset(product)
    #   end
  end
end
