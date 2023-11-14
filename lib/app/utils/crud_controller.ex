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
        |> content(
          main([
            h1("List #{@table}"),
            table([
              thead(
                tr(
                  # Add coll for view button
                  (table_columns() ++ [""])
                  |> Enum.map(&th(to_string(&1) |> String.split("_") |> Enum.join(" ")))
                )
              ),
              DB.list(@table)
              |> Enum.map(fn instance ->
                table_columns()
                |> Enum.map(&Map.fetch!(instance, &1))
                |> Enum.map(&td(&1 |> to_string()))
                |> case do
                  v ->
                    v ++
                      [
                        td(
                          menu(
                            a(
                              onclick: StateService.get(@table, instance["id"]),
                              html: "View"
                            )
                          )
                        )
                      ]
                end
                |> tr()
              end)
              |> case do
                [] -> p("No #{@table |> depluralize()} found")
                x -> x
              end
            ]),
            menu([
              button(
                onclick: StateService.new(@table),
                html: "Create"
              )
            ])
          ])
        )
      end

      def get(conn, %{"id" => id}) do
        case DB.get(@table, id |> String.to_integer()) do
          nil ->
            conn
            |> content("#{@table |> depluralize() |> String.capitalize()} not found")

          instance ->
            conn
            |> content([
              main([
                h1("#{@table |> depluralize() |> String.capitalize()} details"),
                table(
                  table_columns()
                  |> Enum.map(fn field ->
                    tr([
                      th("#{field}"),
                      td(Map.fetch!(instance, field) |> to_string())
                    ])
                  end)
                ),
                menu([
                  # Entity actions
                  a(
                    onclick: StateService.edit(@table, Map.fetch!(instance, "id")),
                    html: "Edit"
                  ),
                  form(
                    "data-action": get_path(__MODULE__, :delete),
                    "data-success": StateService.list(@table),
                    html: [
                      csrf_input(),
                      input(hidden: true, name: "id", value: Map.fetch!(instance, "id")),
                      button(
                        class: "secondary",
                        html: "Delete"
                      )
                    ]
                  )
                ])
              ])
            ])
        end
      end

      def new(conn, _) do
        conn
        |> content(
          main([
            form(
              "data-action": get_path(__MODULE__, :create),
              "data-success": StateService.created(@table),
              html: [
                h1("New #{@table |> depluralize()}"),
                form_fields(nil)
              ]
            )
          ])
        )
      end

      def edit(conn, %{"id" => id}) do
        instance = DB.get(@table, id |> String.to_integer())

        conn
        |> content([
          main([
            form(
              "data-action": get_path(__MODULE__, :update, instance["id"]),
              "data-success": StateService.get(@table, instance["id"]),
              html: [
                h1("Edit #{@table |> StringHelper.depluralize()}"),
                form_fields(instance)
              ]
            )
          ])
        ])
      end

      ### Form actions ###
      def create(conn, params) do
        model = Map.drop(params, ["_csrf_token"])
        cmd = @create_command.changeset(model)

        case DB.create("products", Map.keys(cmd.changes), Map.values(cmd.changes)) do
          id ->
            conn
            |> put_status(201)
            |> json(%{id: id})

          {:error, %Ecto.Changeset{} = cmd} ->
            conn
            |> put_status(422)
            |> json(cmd_errors_map(cmd))
        end
      end

      def update(conn, %{"id" => id} = params) do
        instance = DB.get(@table, id |> String.to_integer())
        model = Map.drop(params, ["_csrf_token"])
        cmd = @create_command.changeset(model)

        case DB.update(@table, instance["id"], cmd.changes) do
          id ->
            conn
            |> send_resp(204, "")

          {:error, %Ecto.Changeset{} = cmd} ->
            conn
            |> put_status(422)
            |> json(cmd_errors_map(cmd))
        end
      end

      def delete(conn, %{"id" => id}) do
        instance = DB.get(@table, id |> String.to_integer())
        # TODO: add 404
        DB.delete(@table, instance["id"])

        conn
        |> send_resp(204, "")
      end

      def table_columns(), do: DB.table_columns(@table)

      defp form_fields(instance) do
        [
          @create_command.changeset(%{})
          |> get_required_fields()
          |> Enum.map(fn x ->
            [
              label(
                html: [
                  x |> to_string(),
                  input(
                    name: "#{x |> to_string()}",
                    value:
                      case instance do
                        nil -> nil
                        _ -> Map.get(instance, x, nil) |> to_string()
                      end
                  )
                ]
              )
            ]
          end),
          csrf_input(),
          button("Submit")
        ]
      end
    end
  end
end
