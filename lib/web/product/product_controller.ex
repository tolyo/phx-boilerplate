defmodule Web.ProductController do
  use Web, :controller

  alias Depot
  @module_schema Depot.Product

  def list(conn, _params) do
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
        |> Enum.map(fn instance ->
          @module_schema.__schema__(:fields)
          |> Enum.map(fn field -> Map.fetch!(instance, field) end)
          |> Enum.map(fn x -> td(x |> to_string()) end)
          |> case do
            v ->
              v ++
                [td(a(href: get_path(__MODULE__, :get, Map.fetch!(instance, :id)), html: "View"))]
          end
          |> tr()
        end)
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

  def get(conn, %{"id" => id}) do
    case Repo.get(@module_schema, id) do
      nil ->
        "#{@module_schema.__schema__(:source) |> StringHelper.depluralize()} not found."

      instance ->
        conn
        |> content([
          @module_schema.__schema__(:fields)
          |> Enum.map(fn field -> {field, Map.fetch!(instance, field)} end)
          |> Enum.map(fn {field, value} -> div("#{field}: #{value |> to_string()}") end)
          |> section(),
          form(
            action: get_path(__MODULE__, :delete, Map.fetch!(instance, :id)),
            html: button("Delete")
          ),
          form(
            action: get_path(__MODULE__, :edit, Map.fetch!(instance, :id)),
            html: button("Update")
          )
        ])
    end
  end

  def edit(conn, %{"id" => id}) do
    instance = Repo.get(@module_schema, id)

    conn
    |> content([
      h1("Update #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"),
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
        action: get_path(__MODULE__, :update, id),
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
                    value: Map.fetch!(instance, x) |> to_string()
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
    insert_action =
      %@module_schema{}
      |> @module_schema.changeset(params)
      |> Repo.insert()

    case insert_action do
      {:ok, _} ->
        conn
        |> put_flash(
          :info,
          "#{@module_schema.__schema__(:source) |> StringHelper.depluralize()} created successfully."
        )
        |> redirect(to: "/products/")

      {:error, %Ecto.Changeset{}} ->
        new(conn, nil)
    end
  end

  def update(conn, %{"id" => id, "model" => params}) do
    instance = Repo.get(@module_schema, id)

    update_action =
      instance
      |> @module_schema.changeset(params)
      |> Repo.update()

    case update_action do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: "/products/")

      {:error, %Ecto.Changeset{}} ->
        edit(conn, %{"id" => id})
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Depot.get_product!(id)
    {:ok, _product} = Repo.delete(product)

    conn
    |> put_flash(
      :info,
      "#{@module_schema.__schema__(:source) |> StringHelper.depluralize()} deleted successfully."
    )
    |> redirect(to: get_path(__MODULE__, :list))
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