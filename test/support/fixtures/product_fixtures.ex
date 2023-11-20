defmodule ProductFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Product` context.
  """
  alias Web.ProductValidator

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    changeset =
      attrs
      |> Enum.into(%{
        title: "some title",
        image_url: "some image_url",
        price: "120.5",
        amount: "1"
      })
      |> ProductValidator.validate()

    DB.create("products", changeset.changes)
  end
end
