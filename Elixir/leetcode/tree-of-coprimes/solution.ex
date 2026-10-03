defmodule Solution do
  @spec get_coprimes(nums :: [integer], edges :: [[integer]]) :: [integer]
  def get_coprimes(nums, edges) do
    n = length(nums)

    if n == 0 do
      []
    else
      t = List.to_tuple(nums)
      adj = build_adj(edges)
      coprime = build_coprime()
      ans = dfs(0, -1, 0, %{}, %{}, %{}, t, adj, coprime)
      Enum.map(0..(n - 1)//1, fn i -> Map.get(ans, i, -1) end)
    end
  end

  defp build_adj(edges) do
    (edges || [])
    |> Enum.reduce(%{}, fn [u, v | _], acc ->
      acc
      |> Map.update(u, [v], &[v | &1])
      |> Map.update(v, [u], &[u | &1])
    end)
  end

  defp build_coprime do
    for a <- 1..50, into: %{} do
      {a, for(b <- 1..50, Integer.gcd(a, b) == 1, do: b)}
    end
  end

  defp dfs(node, parent, depth, dstack, nstack, ans, t, adj, coprime) do
    val = elem(t, node)

    {_best_depth, best_node} =
      coprime
      |> Map.get(val, [])
      |> Enum.reduce({-1, -1}, fn cv, {bd, bn} ->
        case Map.get(dstack, cv) do
          [top_d | _] when top_d > bd ->
            [top_n | _] = Map.get(nstack, cv)
            {top_d, top_n}

          _ ->
            {bd, bn}
        end
      end)

    ans = Map.put(ans, node, best_node)
    dstack2 = Map.update(dstack, val, [depth], &[depth | &1])
    nstack2 = Map.update(nstack, val, [node], &[node | &1])

    adj
    |> Map.get(node, [])
    |> Enum.reduce(ans, fn nb, ans_acc ->
      if nb != parent do
        dfs(nb, node, depth + 1, dstack2, nstack2, ans_acc, t, adj, coprime)
      else
        ans_acc
      end
    end)
  end
end
