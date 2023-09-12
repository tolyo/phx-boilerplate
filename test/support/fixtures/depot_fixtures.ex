defmodule DepotFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Depot` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        title: "some title",
        image_url: "some image_url",
        price: "120.5"
      })
      |> Depot.create_product()

    product
  end
end
