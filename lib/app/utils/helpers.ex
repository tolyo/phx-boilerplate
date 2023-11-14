defmodule CrudHelpers do
  def get_required_fields(%Ecto.Changeset{} = module) do
    required_keys = Keyword.keys(module.errors)

    module.data
    |> Map.keys()
    |> Enum.filter(fn x ->
      x in required_keys
    end)
    |> Enum.map(fn x -> to_string(x) end)
  end

  def maybe_field(nil, _), do: ""
  def maybe_field(%{} = str, field), do: str[field]
end
