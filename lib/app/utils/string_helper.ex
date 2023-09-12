defmodule StringHelper do
  @plural_suffixes ~w(s es ies ves ses)

  def depluralize(word) do
    depluralize(word, @plural_suffixes)
  end

  defp depluralize(word, [suffix | rest]) do
    case String.ends_with?(word, suffix) do
      true -> String.slice(word, 0..(String.length(word) - String.length(suffix) - 1))
      false -> depluralize(word, rest)
    end
  end

  defp depluralize(word, []) do
    word
  end
end
