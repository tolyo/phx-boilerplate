defmodule Components do
  import Nitroux.Utils

  @spec partial(String.t(), String.t() | nil) :: Nitroux.Utils.tag()
  def partial(url, id \\ "#{:rand.uniform(1000)}"), do: tag("partial-component", "data-url": url, id: id)
end
