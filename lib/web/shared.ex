defmodule Web.Shared do
  import Nitroux.Utils

  @spec server_page(String.t()) :: String.t()
  def server_page(url), do: "server-page" |> tag(%{url: url})
end
