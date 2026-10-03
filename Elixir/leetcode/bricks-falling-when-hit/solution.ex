defmodule Solution do
  @spec hit_bricks(grid :: [[integer]], hits :: [[integer]]) :: [integer]
  def hit_bricks(grid, hits) do
    m = length(grid)
    n = if m > 0, do: length(hd(grid)), else: 0
    total = m * n
    top = total

    grid_t = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    cell = fn r, c -> elem(elem(grid_t, r), c) end
    in_bounds = fn r, c -> r >= 0 and r < m and c >= 0 and c < n end

    # working grid: a MapSet of {r, c} where a brick currently stands
    g0 =
      for r <- 0..(m - 1)//1, c <- 0..(n - 1)//1, cell.(r, c) == 1, into: MapSet.new() do
        {r, c}
      end

    hits_list = Enum.map(hits, fn [r, c] -> {r, c} end)

    # erase the hit bricks up-front
    g =
      Enum.reduce(hits_list, g0, fn {r, c}, g ->
        if in_bounds.(r, c), do: MapSet.delete(g, {r, c}), else: g
      end)

    # build union-find over the bricks that remain
    {parent, size} =
      Enum.reduce(0..(m - 1)//1, {%{}, %{}}, fn r, acc ->
        Enum.reduce(0..(n - 1)//1, acc, fn c, {parent, size} ->
          if MapSet.member?(g, {r, c}) do
            cur = r * n + c
            {parent, size} = if r == 0, do: union(parent, size, cur, top), else: {parent, size}

            {parent, size} =
              if r > 0 and MapSet.member?(g, {r - 1, c}),
                do: union(parent, size, cur, (r - 1) * n + c),
                else: {parent, size}

            if c > 0 and MapSet.member?(g, {r, c - 1}),
              do: union(parent, size, cur, r * n + c - 1),
              else: {parent, size}
          else
            {parent, size}
          end
        end)
      end)

    dirs = [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    nh = length(hits_list)
    hits_t = List.to_tuple(hits_list)

    {result_map, _g, _parent, _size} =
      Enum.reduce((nh - 1)..0//-1, {%{}, g, parent, size}, fn i, {res, g, parent, size} ->
        {r, c} = elem(hits_t, i)

        cond do
          not in_bounds.(r, c) ->
            {res, g, parent, size}

          # only a brick that originally existed there can fall back into place
          cell.(r, c) != 1 ->
            {res, g, parent, size}

          true ->
            {root_before, parent} = find(parent, top)
            before = Map.get(size, root_before, 1)
            g = MapSet.put(g, {r, c})
            cur = r * n + c
            {parent, size} = if r == 0, do: union(parent, size, cur, top), else: {parent, size}

            {parent, size} =
              Enum.reduce(dirs, {parent, size}, fn {dr, dc}, {parent, size} ->
                nr = r + dr
                nc = c + dc

                if in_bounds.(nr, nc) and MapSet.member?(g, {nr, nc}) do
                  union(parent, size, cur, nr * n + nc)
                else
                  {parent, size}
                end
              end)

            {root_after, parent} = find(parent, top)
            after_ = Map.get(size, root_after, 1)
            val = max(0, after_ - before - 1)
            {Map.put(res, i, val), g, parent, size}
        end
      end)

    Enum.map(0..(nh - 1)//1, fn i -> Map.get(result_map, i, 0) end)
  end

  # union-find with path halving
  defp find(parent, x) do
    p = Map.get(parent, x, x)

    if p == x do
      {x, parent}
    else
      gp = Map.get(parent, p, p)
      find(Map.put(parent, x, gp), gp)
    end
  end

  defp union(parent, size, a, b) do
    {ra, parent} = find(parent, a)
    {rb, parent} = find(parent, b)

    if ra == rb do
      {parent, size}
    else
      # union by size: attach the smaller tree under the larger root
      {ra, rb} =
        if Map.get(size, ra, 1) < Map.get(size, rb, 1), do: {rb, ra}, else: {ra, rb}

      sra = Map.get(size, ra, 1)
      srb = Map.get(size, rb, 1)
      {Map.put(parent, rb, ra), Map.put(size, ra, sra + srb)}
    end
  end
end
