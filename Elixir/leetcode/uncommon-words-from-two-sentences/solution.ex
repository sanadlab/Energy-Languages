defmodule Solution do
  @spec uncommon_from_sentences(s1 :: String.t, s2 :: String.t) :: [String.t]
  def uncommon_from_sentences(s1, s2) do
    (s1 <> " " <> s2)
    |> String.split()
    |> Enum.reduce(%{}, fn w, acc -> Map.update(acc, w, 1, &(&1 + 1)) end)
    |> Enum.filter(fn {_w, count} -> count == 1 end)
    |> Enum.map(fn {w, _count} -> w end)
  end
end
