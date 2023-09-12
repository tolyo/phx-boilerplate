defmodule Web.ProductController do
  use Web, :controller

  alias Depot
  alias Depot.Product
  @module_schema Depot.Product

  def index(conn, _params) do
    items = @module_schema |> Repo.all()

    conn
    |> content([
      h1("List #{@module_schema.__schema__(:source)}"),
      table([
        ([
           tr(
             @module_schema.__schema__(:fields)
             |> Enum.map(&th(to_string(&1)))
           )
         ] ++ items)
        |> Enum.map(&td(to_string(&1)))
      ]),
      a(
        href: Routes.product_path(conn, :new),
        html: "New #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"
      )
    ])
  end

  def new(conn, _params) do
    changeset = Depot.change_product(%Product{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"product" => product_params}) do
    case Depot.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: "/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Depot.get_product!(id)
    render(conn, :show, product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Depot.get_product!(id)
    changeset = Depot.change_product(product)
    render(conn, :edit, product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Depot.get_product!(id)

    case Depot.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: "/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Depot.get_product!(id)
    {:ok, _product} = Depot.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: "/products")
  end
end
