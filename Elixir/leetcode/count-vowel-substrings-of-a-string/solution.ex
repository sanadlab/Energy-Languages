defmodule Solution do
  @spec count_vowel_substrings(word :: String.t) :: integer
  def count_vowel_substrings(word) do
    arr = word |> String.to_charlist() |> List.to_tuple()
    n = tuple_size(arr)
    outer(arr, n, 0, 0)
  end

  defp outer(_arr, n, i, count) when i >= n, do: count
  defp outer(arr, n, i, count) do
    if vowel?(elem(arr, i)) do
      outer(arr, n, i + 1, inner(arr, n, i, MapSet.new(), count))
    else
      outer(arr, n, i + 1, count)
    end
  end

  defp inner(arr, n, j, seen, count) when j < n do
    c = elem(arr, j)
    if vowel?(c) do
      seen = MapSet.put(seen, c)
      count = if MapSet.size(seen) == 5, do: count + 1, else: count
      inner(arr, n, j + 1, seen, count)
    else
      count
    end
  end
  defp inner(_arr, _n, _j, _seen, count), do: count

  defp vowel?(c), do: c in [?a, ?e, ?i, ?o, ?u]
end
