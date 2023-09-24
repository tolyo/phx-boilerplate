defmodule Validation do
  @spec cmd_errors_map(%Ecto.Changeset{}) :: %{String.t() => String.t()}
  def cmd_errors_map(cmd) do
    cmd.errors
    |> Enum.reduce(%{}, fn {field, {error, _}}, acc ->
      Map.put(acc, field, Gettext.dgettext(Web.Gettext, "errors", error))
    end)
  end
end
