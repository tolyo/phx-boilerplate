defmodule Components do
  import Nitroux.Utils

  @spec partial(String.t()) :: Nitroux.Utils.tag()
  def partial(url), do: tag("partial-component", "data-url": url)
end
