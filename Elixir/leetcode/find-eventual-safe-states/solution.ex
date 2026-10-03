defmodule Solution do
  @spec eventual_safe_nodes(graph :: [[integer]]) :: [integer]
  def eventual_safe_nodes(graph) do
    n = length(graph)
    nodes = if n == 0, do: [], else: Enum.to_list(0..(n - 1))

    {rev, outdeg} =
      graph
      |> Enum.with_index()
      |> Enum.reduce({%{}, %{}}, fn {row, u}, {rev, outdeg} ->
        row = if is_list(row), do: row, else: []

        Enum.reduce(row, {rev, outdeg}, fn v, {rev, outdeg} ->
          if v >= 0 and v < n do
            {Map.update(rev, v, [u], &[u | &1]), Map.update(outdeg, u, 1, &(&1 + 1))}
          else
            {rev, outdeg}
          end
        end)
      end)

    queue = Enum.filter(nodes, fn i -> Map.get(outdeg, i, 0) == 0 end)
    safe = process(queue, rev, outdeg, MapSet.new())
    Enum.filter(nodes, &MapSet.member?(safe, &1))
  end

  defp process([], _rev, _outdeg, safe), do: safe
  defp process([v | rest], rev, outdeg, safe) do
    safe = MapSet.put(safe, v)

    {rest, outdeg} =
      Enum.reduce(Map.get(rev, v, []), {rest, outdeg}, fn u, {q, od} ->
        nd = Map.get(od, u) - 1
        od = Map.put(od, u, nd)
        q = if nd == 0, do: [u | q], else: q
        {q, od}
      end)

    process(rest, rev, outdeg, safe)
  end
end
