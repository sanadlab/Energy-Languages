defmodule Solution do
  @spec regions_by_slashes(grid :: [String.t]) :: integer
  def regions_by_slashes(grid) do
    n = length(grid)

    rows_t =
      grid
      |> Enum.map(fn row -> row |> :binary.bin_to_list() |> List.to_tuple() end)
      |> List.to_tuple()

    cells = for r <- 0..(n - 1)//1, c <- 0..(n - 1)//1, do: {r, c}

    parent =
      Enum.reduce(cells, %{}, fn {r, c}, parent ->
        base = 4 * (r * n + c)
        top = base
        right = base + 1
        bottom = base + 2
        left = base + 3

        row_t = elem(rows_t, r)
        ch = if c < tuple_size(row_t), do: elem(row_t, c), else: ?\s

        parent =
          cond do
            ch == ?/ ->
              parent |> union(top, left) |> union(right, bottom)

            ch == ?\\ ->
              parent |> union(top, right) |> union(left, bottom)

            true ->
              parent |> union(top, right) |> union(right, bottom) |> union(bottom, left)
          end

        parent =
          if c + 1 < n, do: union(parent, right, 4 * (r * n + c + 1) + 3), else: parent

        if r + 1 < n, do: union(parent, bottom, 4 * ((r + 1) * n + c)), else: parent
      end)

    total = 4 * n * n

    {count, _} =
      Enum.reduce(0..(total - 1)//1, {0, parent}, fn i, {cnt, p} ->
        {root, p2} = find(p, i)
        {if(root == i, do: cnt + 1, else: cnt), p2}
      end)

    count
  end

  # Union-Find over a persistent Map. Absent keys are their own parent, so the
  # identity forest needs no initialization.
  defp find(parent, x) do
    px = Map.get(parent, x, x)

    if px == x do
      {x, parent}
    else
      ppx = Map.get(parent, px, px)
      find(Map.put(parent, x, ppx), ppx)
    end
  end

  defp union(parent, a, b) do
    {ra, p1} = find(parent, a)
    {rb, p2} = find(p1, b)

    if ra != rb, do: Map.put(p2, ra, rb), else: p2
  end
end
