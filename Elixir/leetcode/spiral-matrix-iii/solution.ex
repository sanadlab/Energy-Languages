defmodule Solution do
  @spec spiral_matrix_iii(rows :: integer, cols :: integer, r_start :: integer, c_start :: integer) :: [[integer]]
  def spiral_matrix_iii(rows, cols, r_start, c_start) do
    total = rows * cols

    {res0, cnt0} =
      if in_bounds?(r_start, c_start, rows, cols) do
        {[[r_start, c_start]], 1}
      else
        {[], 0}
      end

    loop(rows, cols, r_start, c_start, 1, 0, total, res0, cnt0)
    |> Enum.reverse()
  end

  defp loop(rows, cols, r, c, step, d, total, res, cnt) do
    if cnt >= total do
      res
    else
      {r, c, res, cnt} = leg(rows, cols, r, c, step, d, res, cnt)
      {r, c, res, cnt} = leg(rows, cols, r, c, step, d + 1, res, cnt)
      loop(rows, cols, r, c, step + 1, d + 2, total, res, cnt)
    end
  end

  defp leg(rows, cols, r, c, step, d, res, cnt) do
    {dr, dc} = dir(rem(d, 4))

    Enum.reduce(1..step, {r, c, res, cnt}, fn _, {r, c, res, cnt} ->
      r = r + dr
      c = c + dc

      if in_bounds?(r, c, rows, cols) do
        {r, c, [[r, c] | res], cnt + 1}
      else
        {r, c, res, cnt}
      end
    end)
  end

  defp dir(0), do: {0, 1}
  defp dir(1), do: {1, 0}
  defp dir(2), do: {0, -1}
  defp dir(3), do: {-1, 0}

  defp in_bounds?(r, c, rows, cols), do: r >= 0 and r < rows and c >= 0 and c < cols
end
