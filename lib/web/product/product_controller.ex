defmodule Web.ProductController do
  use Web, :controller

  alias Depot
  @module_schema Depot.Product

  def index(conn, _params) do
    conn
    |> content([
      h1("List #{@module_schema.__schema__(:source)}"),
      table([
        tr(
          @module_schema.__schema__(:fields)
          |> Enum.map(&th(to_string(&1)))
        ),
        @module_schema
        |> Repo.all()
        |> Enum.map(&td(to_string(&1)))
        |> case do
          [] -> p("No #{@module_schema.__schema__(:source)} found")
          x -> x
        end
      ]),
      a(
        href: get_path(__MODULE__, :new),
        html: "New #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"
      )
    ])
  end

  def new(conn, _params) do
    conn
    |> content([
      h1("New #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"),
      case conn.params["model"] do
        nil ->
          nil

        v ->
          @module_schema.changeset(%@module_schema{}, v).errors
          |> Enum.map(fn {key, {error, _}} -> li("#{key}: #{error}") end)
          |> ul()
      end,
      form(
        method: "POST",
        action: get_path(__MODULE__, :create),
        html: [
          @module_schema.changeset(%@module_schema{}, %{})
          |> get_required_fields()
          |> Enum.map(fn x ->
            [
              label(
                html: [
                  x |> to_string(),
                  input(
                    name: "model[#{x |> to_string()}]",
                    value: maybe_field(conn.params["model"], x |> to_string())
                  )
                ]
              )
            ]
          end),
          input(
            type: "hidden",
            name: ~c"_csrf_token",
            value: get_csrf_token()
          ),
          button("Submit")
        ]
      )
    ])
  end

  def create(conn, %{"model" => params}) do
    case @module_schema.changeset(%@module_schema{}, params) |> Repo.insert() do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product created successfully.")
        |> redirect(to: "/products/#{product}")

      {:error, %Ecto.Changeset{} = changeset} ->
        new(conn, changeset: changeset)
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

  def get_required_fields(%Ecto.Changeset{} = module) do
    required_keys = Keyword.keys(module.errors)

    module.data
    |> Map.keys()
    |> Enum.filter(fn x ->
      x in required_keys
    end)
  end

  def maybe_field(nil, _), do: ""
  def maybe_field(%{} = str, field), do: str[field]
end
