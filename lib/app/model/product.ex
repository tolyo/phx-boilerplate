defmodule Product do
  use Ecto.Schema
  import Ecto.Query, warn: false
  import Ecto.Changeset

  @behaviour CrudBehavior

  @derive Jason.Encoder
  schema "products" do
    field :title, :string
    field :image_url, :string
    field :price, :decimal

    timestamps()
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:title, :image_url, :price])
    |> validate_required([:title, :image_url, :price])
  end

  @doc """
  Returns the list of products.

  ## Examples

      iex> list()
      [%Product{}, ...]

  """
  def list() do
    Repo.all(__MODULE__)
  end

  @doc """
  Gets a single product.

  Returns nil if the Product does not exist.

  ## Examples

      iex> get(123)
      %Product{}

      iex> get(456)
      ** nil

  """
  def get(id), do: Repo.get(__MODULE__, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Product{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%__MODULE__{} = instance, attrs) do
    instance
    |> __MODULE__.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete(product)
      {:ok, %Product{}}

      iex> delete(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%__MODULE__{} = instance) do
    Repo.delete(instance)
  end
end
