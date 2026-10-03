defmodule Solution do
  @spec restore_array(adjacent_pairs :: [[integer]]) :: [integer]
  def restore_array(adjacent_pairs) do
    adj =
      Enum.reduce(adjacent_pairs, %{}, fn [u, v], acc ->
        acc
        |> Map.update(u, [v], &[v | &1])
        |> Map.update(v, [u], &[u | &1])
      end)

    n = length(adjacent_pairs) + 1
    start = find_start(adj)
    walk(adj, start, nil, false, n - 1, [start]) |> Enum.reverse()
  end

  defp find_start(adj) do
    Enum.find_value(adj, fn {node, nbrs} -> if length(nbrs) == 1, do: {:ok, node} end)
    |> case do
      {:ok, node} -> node
      _ -> nil
    end
  end

  defp walk(adj, cur, prev, has_prev, remaining, res) when remaining > 0 do
    nbrs = Map.get(adj, cur, [])
    nxt = Enum.find(nbrs, fn x -> not has_prev or x != prev end)

    case nxt do
      nil -> res
      _ -> walk(adj, nxt, cur, true, remaining - 1, [nxt | res])
    end
  end
  defp walk(_adj, _cur, _prev, _has_prev, _remaining, res), do: res
end
