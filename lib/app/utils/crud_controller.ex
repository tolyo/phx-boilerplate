defmodule CrudController do
  defmacro __using__(_opts) do
    import CrudHelpers
    import Validation

    quote do
      ### Views ###
      def list(conn, _) do
        conn
        |> content([
          h1("List #{@module_schema.__schema__(:source)}"),
          table([
            thead(
              tr(
                # Add coll for view button
                (@module_schema.__schema__(:fields) ++ [""])
                |> Enum.map(&th(to_string(&1) |> String.split("_") |> Enum.join(" ")))
              )
            ),
            @module_schema.list()
            |> Enum.map(fn instance ->
              @module_schema.__schema__(:fields)
              |> Enum.map(fn field -> Map.fetch!(instance, field) end)
              |> Enum.map(fn x -> td(x |> to_string()) end)
              |> case do
                v ->
                  v ++
                    [
                      td(
                        a(
                          onclick:
                            "stateService.go('#{@module_schema.__schema__(:source)}:get', {'id': #{Map.fetch!(instance, :id)}})",
                          html: "View"
                        )
                      )
                    ]
              end
              |> tr()
            end)
            |> case do
              [] -> p("No #{@module_schema.__schema__(:source)} found")
              x -> x
            end
          ]),
          a(
            onclick: "stateService.go('#{@module_schema.__schema__(:source)}:new')",
            html: "New #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"
          )
        ])
      end

      def get(conn, %{"id" => id}) do
        case @module_schema.get(id) do
          nil ->
            conn
            |> content(
              "#{@module_schema.__schema__(:source) |> StringHelper.depluralize() |> String.capitalize()} not found"
            )

          instance ->
            conn
            |> content([
              h1(
                "#{@module_schema.__schema__(:source) |> StringHelper.depluralize() |> String.capitalize()} details"
              ),

              # Entity view
              @module_schema.__schema__(:fields)
              |> Enum.map(fn field -> {field, Map.fetch!(instance, field)} end)
              |> Enum.map(fn {field, value} ->
                tr([
                  th("#{field}"),
                  td("#{value |> to_string()}")
                ])
              end)
              |> table(),
              footer([
                # Entity actions
                button(
                  onclick:
                    "stateService.go('#{@module_schema.__schema__(:source)}:edit', {'id': #{Map.fetch!(instance, :id)}})",
                  html: "Edit"
                ),
                form(
                  action: get_path(__MODULE__, :delete, Map.fetch!(instance, :id)),
                  method: "GET",
                  "on-success": "stateService.go('#{@module_schema.__schema__(:source)}')",
                  html:
                    button(
                      class: "secondary",
                      html: "Delete"
                    )
                )
              ])
            ])
        end
      end

      def new(conn, _) do
        conn
        |> content([
          h1("New #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"),
          form(
            method: "POST",
            action: get_path(__MODULE__, :create),
            "on-success": "stateService.go('#{@module_schema.__schema__(:source)}')",
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

      def edit(conn, %{"id" => id}) do
        instance = @module_schema.get(id)

        conn
        |> content([
          h1("Edit #{@module_schema.__schema__(:source) |> StringHelper.depluralize()}"),
          form(
            method: "POST",
            action: get_path(__MODULE__, :update, instance.id),
            "on-success":
              "stateService.go('#{@module_schema.__schema__(:source)}:get', {'id': #{Map.fetch!(instance, :id)}})",
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
            |> put_status(201)
            |> json(nil)

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
        |> put_flash(
          :info,
          "#{@module_schema.__schema__(:source) |> StringHelper.depluralize()} deleted successfully."
        )
        |> redirect(to: "/#{@module_schema.__schema__(:source)}")
      end
    end
  end
end
