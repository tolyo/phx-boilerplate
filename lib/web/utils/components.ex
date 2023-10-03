defmodule Components do
  import Nitroux.Utils

  @spec partial(String.t()) :: Nitroux.Utils.tag()
  def partial(url), do: tag("partial-component", url: url)
end
