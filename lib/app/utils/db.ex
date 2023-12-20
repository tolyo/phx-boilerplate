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

  @spec get(binary(), any()) :: map()
  def get(table_name, id) do
    columns = table_columns(table_name)

    DB.query("SELECT * FROM " <> table_name <> " WHERE id = $1", [id])
    |> Enum.map(fn row ->
      Enum.zip(columns, row) |> Map.new()
    end)
    |> List.first()
  end

  @spec delete(String.t(), any) :: any()
  def delete(table_name, id) do
    DB.query(
      "DELETE FROM " <>
        table_name <>
        " WHERE id = $1",
      [id]
    )
  end

  @spec table_columns(any()) :: list()
  def table_columns(table) do
    DB.query(
      "SELECT *
      FROM information_schema.columns
      WHERE table_name = $1",
      [table]
    )
    |> Enum.sort_by(&Enum.at(&1, 4))
    |> Enum.map(&Enum.at(&1, 3))
  end

  @spec create(String.t(), map()) :: String.t() | number()
  def create(table_name, params) do
    query = """
      INSERT INTO #{table_name} (#{Enum.join(Map.keys(params), ", ")})
      VALUES (#{1..length(Map.values(params)) |> Enum.map(fn x -> "$" <> Integer.to_string(x) end) |> Enum.join(", ")})
      RETURNING id
    """

    [[x]] = DB.query(query, Map.values(params))
    x
  end

  def update(table_name, id, params) do
    query = """
      UPDATE #{table_name}
      SET #{params |> Map.keys() |> Enum.with_index(fn x, i -> "#{x} = $#{i + 1}" end) |> Enum.join(", ")}
      WHERE id = #{id}
    """

    IO.puts(query)
    DB.query(query, Map.values(params))
  end
end
