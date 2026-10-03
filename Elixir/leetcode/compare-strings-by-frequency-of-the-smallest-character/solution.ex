defmodule Solution do
  @spec num_smaller_by_frequency(queries :: [String.t], words :: [String.t]) :: [integer]
  def num_smaller_by_frequency(queries, words) do
    word_freqs = words |> Enum.map(&f/1) |> Enum.sort()
    wf = List.to_tuple(word_freqs)
    n = tuple_size(wf)

    Enum.map(queries, fn query ->
      q_freq = f(query)
      idx = binary_search(wf, 0, n - 1, q_freq + 1)
      n - idx
    end)
  end

  # f(s): frequency of the lexicographically smallest character in s
  defp f(s) do
    bytes = :binary.bin_to_list(s)
    min_char = Enum.min(bytes)
    Enum.count(bytes, &(&1 == min_char))
  end

  defp binary_search(_wf, left, right, _target) when left > right, do: left

  defp binary_search(wf, left, right, target) do
    mid = div(left + right, 2)

    if elem(wf, mid) < target do
      binary_search(wf, mid + 1, right, target)
    else
      binary_search(wf, left, mid - 1, target)
    end
  end
end
