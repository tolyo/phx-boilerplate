defmodule Inherit do
  @moduledoc """
  Source: https://blixtdev.com/dont-do-this-object-oriented-inheritance-in-elixir-with-macros/
  """
  defmacro __using__(quoted_module) do
    module = Macro.expand(quoted_module, __ENV__)

    module.__info__(:functions)
    |> Enum.map(fn {name, arity} ->
      # Generate an argument list of length `arity`
      args = (arity == 0 && []) || 1..arity |> Enum.map(&Macro.var(:"arg#{&1}", nil))

      quote do
        defdelegate unquote(name)(unquote_splicing(args)), to: unquote(module)
        defoverridable [{unquote(name), unquote(arity)}]
      end
    end)
  end
end
