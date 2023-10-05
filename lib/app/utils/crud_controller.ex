defmodule CrudController do
  defmacro __using__(_opts) do
    import CrudHelpers
    import Validation
    import StringHelper
    import Forms

    quote do
      ### Views ###
      def list(conn, _) do
        conn
        |> content([
          h1("List #{entity()}"),
          table([
            thead(
              tr(
                # Add coll for view button
                (entity_fields() ++ [""])
                |> Enum.map(&th(to_string(&1) |> String.split("_") |> Enum.join(" ")))
              )
            ),
            @module_schema.list()
            |> Enum.map(fn instance ->
              entity_fields()
              |> Enum.map(&Map.fetch!(instance, &1))
              |> Enum.map(&td(&1 |> to_string()))
              |> case do
                v ->
                  v ++
                    [
                      td(
                        a(
                          onclick: StateService.get(entity(), Map.fetch!(instance, :id)),
                          html: "View"
                        )
                      )
                    ]
              end
              |> tr()
            end)
            |> case do
              [] -> p("No #{entity() |> depluralize()} found")
              x -> x
            end
          ]),
          a(
            onclick: StateService.new(entity()),
            html: "New #{entity() |> depluralize()}"
          )
        ])
      end

      def get(conn, %{"id" => id}) do
        case @module_schema.get(id) do
          nil ->
            conn
            |> content("#{entity() |> depluralize() |> String.capitalize()} not found")

          instance ->
            conn
            |> content([
              h1("#{entity() |> depluralize() |> String.capitalize()} details"),

              # Entity view
              entity_fields()
              |> Enum.map(fn field ->
                tr([
                  th("#{field}"),
                  td("#{Map.fetch!(instance, field) |> to_string()}")
                ])
              end)
              |> table(),
              footer([
                # Entity actions
                button(
                  onclick: StateService.edit(entity(), Map.fetch!(instance, :id)),
                  html: "Edit"
                ),
                form(
                  "data-action": get_path(__MODULE__, :delete),
                  "data-success": StateService.list(entity()),
                  html: [
                    csrf_input(),
                    input(hidden: true, name: "id", value: Map.fetch!(instance, :id)),
                    button(
                      class: "secondary",
                      html: "Delete"
                    )
                  ]
                )
              ])
            ])
        end
      end

      def new(conn, _) do
        conn
        |> content([
          h1("New #{entity() |> depluralize()}"),
          form(
            "data-action": get_path(__MODULE__, :create),
            "data-success": StateService.created(entity()),
            html: [
              @module_schema.changeset(%@module_schema{}, %{})
              |> get_required_fields()
              |> Enum.map(fn x ->
                [
                  label(
                    html: [
                      x |> to_string(),
                      input(
                        name: "#{x |> to_string()}",
                        value: maybe_field(conn.params["model"], x |> to_string())
                      )
                    ]
                  )
                ]
              end),
              csrf_input(),
              button("Submit")
            ]
          )
        ])
      end

      def edit(conn, %{"id" => id}) do
        instance = @module_schema.get(id)

        conn
        |> content([
          h1("Edit #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"),
          form(
            "data-action": get_path(__MODULE__, :update, instance.id),
            "data-success": StateService.get(entity(), Map.fetch!(instance, :id)),
            html: [
              @module_schema.changeset(%@module_schema{}, %{})
              |> get_required_fields()
              |> Enum.map(fn x ->
                [
                  label(
                    html: [
                      x |> to_string(),
                      input(
                        name: "#{x |> to_string()}",
                        value: Map.fetch!(instance, x) |> to_string()
                      )
                    ]
                  )
                ]
              end),
              csrf_input(),
              button("Submit")
            ]
          )
        ])
      end

      ### Form actions ###
      def create(conn, params) do
        case @module_schema.create(params) do
          {:ok, instance} ->
            conn
            |> put_status(201)
            |> json(%{id: instance.id})

          {:error, %Ecto.Changeset{} = cmd} ->
            conn
            |> put_status(422)
            |> json(cmd_errors_map(cmd))
        end
      end

      def update(conn, %{"id" => id} = params) do
        instance = @module_schema.get(id)

        case @module_schema.update(instance, params) do
          {:ok, _} ->
            conn
            |> send_resp(204, "")

          {:error, %Ecto.Changeset{} = cmd} ->
            conn
            |> put_status(422)
            |> json(cmd_errors_map(cmd))
        end
      end

      def delete(conn, %{"id" => id}) do
        instance = @module_schema.get(id)
        # TODO: add 404
        {:ok, _} = Repo.delete(instance)

        conn
        |> send_resp(204, "")
      end

      def entity(), do: @module_schema.__schema__(:source)
      def entity_fields(), do: @module_schema.__schema__(:fields)
    end
  end
end
