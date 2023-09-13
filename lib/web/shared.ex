defmodule Web.Shared do
  import Nitroux.Utils

  @spec server_page(String.t()) :: String.t()
  def server_page(url), do: "server-page" |> tag(url: url)

  def get_path(module, path) do
    Web.Router.__routes__()
    |> Enum.find(fn x -> x.plug == module && x.plug_opts == path end)
    |> case do
      x -> x.path
    end
  end
end
