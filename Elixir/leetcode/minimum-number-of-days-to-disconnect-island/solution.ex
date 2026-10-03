defmodule Solution do
  @spec min_days(grid :: [[integer]]) :: integer
  def min_days(grid) do
    rows = length(grid)
    cols = length(hd(grid))

    land =
      MapSet.new(
        for {row, i} <- Enum.with_index(grid),
            {v, j} <- Enum.with_index(row),
            v == 1,
            do: {i, j}
      )

    if count_islands(land) != 1 do
      0
    else
      disconnectable =
        Enum.any?(land, fn cell -> count_islands(MapSet.delete(land, cell)) != 1 end)

      _ = {rows, cols}
      if disconnectable, do: 1, else: 2
    end
  end

  defp count_islands(land) do
    {count, _visited} =
      Enum.reduce(land, {0, MapSet.new()}, fn cell, {count, visited} ->
        if MapSet.member?(visited, cell) do
          {count, visited}
        else
          {count + 1, dfs([cell], land, visited)}
        end
      end)

    count
  end

  defp dfs([], _land, visited), do: visited
  defp dfs([cell | stack], land, visited) do
    if MapSet.member?(visited, cell) do
      dfs(stack, land, visited)
    else
      visited = MapSet.put(visited, cell)
      {i, j} = cell

      neighbors =
        for {di, dj} <- [{1, 0}, {-1, 0}, {0, 1}, {0, -1}],
            nb = {i + di, j + dj},
            MapSet.member?(land, nb) and not MapSet.member?(visited, nb),
            do: nb

      dfs(neighbors ++ stack, land, visited)
    end
  end
end
