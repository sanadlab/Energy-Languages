defmodule Solution do
  @spec close_strings(word1 :: String.t, word2 :: String.t) :: boolean
  def close_strings(word1, word2) do
    if String.length(word1) != String.length(word2) do
      false
    else
      freq1 = freq(word1)
      freq2 = freq(word2)

      same_set =
        Enum.zip(freq1, freq2)
        |> Enum.all?(fn {a, b} -> not ((a > 0 and b == 0) or (b > 0 and a == 0)) end)

      same_set and Enum.sort(freq1) == Enum.sort(freq2)
    end
  end

  defp freq(w) do
    counts =
      w
      |> :binary.bin_to_list()
      |> Enum.reduce(%{}, fn b, acc -> Map.update(acc, b - ?a, 1, &(&1 + 1)) end)

    for i <- 0..25, do: Map.get(counts, i, 0)
  end
end
