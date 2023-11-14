defmodule ProductValidator do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :image_url, :string
    field :amount, :integer
    field :price, :decimal
  end

  @doc false
  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:title, :image_url, :amount, :price])
    |> validate_required([:title, :image_url, :amount, :price])
  end
end
