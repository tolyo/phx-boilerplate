defmodule DB do
  def query(statement, params \\ []) do
    case Postgrex.query(:db, statement, params, []) do
      {:ok, res} -> res.rows
      {:error, error} -> error
    end
  end

  def list(table_name) do
    columns = table_columns(table_name)

    DB.query("SELECT * FROM " <> table_name)
    |> Enum.map(fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
  end

  def get(table_name, id) do
    columns = table_columns(table_name)

    DB.query("SELECT * FROM " <> table_name <> " WHERE id=$1", [id])
    |> Enum.map(fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
    |> List.first()
  end

  @spec table_columns(any()) :: list()
  def table_columns(table) do
    DB.query(
      "SELECT *
      FROM information_schema.columns
      WHERE table_name=$1",
      [table]
    )
    |> Enum.sort_by(&Enum.at(&1, 4))
    |> Enum.map(&Enum.at(&1, 3))
  end

  def create(table_name, columns, params) do
    IO.puts(params)
    query = "INSERT INTO #{table_name} (#{Enum.join(columns, ", ")}) VALUES ($1, $2, $3)"
    IO.puts(query)
    DB.query(query, params)
  end
end
