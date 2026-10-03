defmodule Solution do
  @spec remove_invalid_parentheses(s :: String.t) :: [String.t]
  def remove_invalid_parentheses(s) do
    bfs(MapSet.new([s]))
  end

  defp bfs(level) do
    if MapSet.size(level) == 0 do
      [""]
    else
      valids = level |> Enum.filter(&valid?/1)

      if valids != [] do
        valids
      else
        nxt = Enum.reduce(level, MapSet.new(), &add_removals/2)
        bfs(nxt)
      end
    end
  end

  defp valid?(st) do
    st
    |> String.to_charlist()
    |> Enum.reduce_while(0, fn ch, cnt ->
      cond do
        ch == ?( -> {:cont, cnt + 1}
        ch == ?) -> if cnt - 1 < 0, do: {:halt, :invalid}, else: {:cont, cnt - 1}
        true -> {:cont, cnt}
      end
    end)
    |> case do
      :invalid -> false
      cnt -> cnt == 0
    end
  end

  defp add_removals(st, acc) do
    len = String.length(st)

    Enum.reduce(0..(len - 1), acc, fn i, acc2 ->
      ch = String.at(st, i)

      if ch == "(" or ch == ")" do
        removed = String.slice(st, 0, i) <> String.slice(st, i + 1, len)
        MapSet.put(acc2, removed)
      else
        acc2
      end
    end)
  end
end
