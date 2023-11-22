# Global helpers
defmodule Web.ViewHelpers do

  def json(val) do
    {:ok, body} = Jason.encode(val)
    body |> String.replace("\"", "'")
  end
end
