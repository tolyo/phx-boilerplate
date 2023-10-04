defmodule Forms do
  @doc """
  Helper for generating hidden input fields on forms.
  Example:
    form([
        csrf_input(),
        button("Submit")
    ])
  """
  @spec csrf_input() :: Nitroux.Types.tag()
  def csrf_input() do
    Nitroux.input(
      type: "hidden",
      name: "_csrf_token",
      value: Plug.CSRFProtection.get_csrf_token()
    )
  end
end
