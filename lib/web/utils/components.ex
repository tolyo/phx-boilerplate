defmodule Components do
  import Nitroux.Utils

  @spec partial(String.t(), String.t()) :: Nitroux.Utils.tag()
  def partial(url, id \\ nil), do: tag("partial-component", "data-url": url, id: id)
end
