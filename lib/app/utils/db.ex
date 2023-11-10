defmodule DB do
  def query(statement, params \\ []) do
    case Postgrex.query(:db, statement, params, []) do
      {:ok, res} -> res.rows
      {:error, error} -> error
    end
  end

  def list(table_name) do
    DB.query("SELECT * FROM " <> table_name)
  end
end
