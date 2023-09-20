defmodule Web.Shared do
  @doc """
  Generates dynamic paths with optional primary key to pass
  """
  @spec get_path(any, any, nil | String.t()) :: any
  def get_path(module, path, attrs \\ nil) do
    path =
      Web.Router.__routes__()
      |> Enum.find(fn x -> x.plug == module && x.plug_opts == path end)
      |> case do
        x -> x.path
      end

    case attrs do
      nil -> path
      _ -> String.replace(path, ":id", to_string(attrs))
    end
  end
end
