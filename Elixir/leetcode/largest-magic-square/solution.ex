defmodule Solution do
  @spec largest_magic_square(grid :: [[integer]]) :: integer
  def largest_magic_square(grid) do
    m = length(grid)
    n = length(hd(grid))
    g = grid |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
    cell = fn i, j -> elem(elem(g, i), j) end
    kmax = min(m, n)

    Enum.reduce_while(kmax..2//-1, 1, fn k, _acc ->
      found =
        Enum.any?(0..(m - k), fn i ->
          Enum.any?(0..(n - k), fn j ->
            magic?(cell, i, j, k)
          end)
        end)

      if found, do: {:halt, k}, else: {:cont, 1}
    end)
  end

  defp magic?(cell, r, c, k) do
    total = Enum.reduce(0..(k - 1), 0, fn j, acc -> acc + cell.(r + k - 1, c + j) end)

    rows_cols_ok =
      Enum.all?(0..(k - 1), fn i ->
        row_sum = Enum.reduce(0..(k - 1), 0, fn j, acc -> acc + cell.(r + i, c + j) end)
        col_sum = Enum.reduce(0..(k - 1), 0, fn j, acc -> acc + cell.(r + j, c + i) end)
        row_sum == total and col_sum == total
      end)

    if rows_cols_ok do
      diag1 = Enum.reduce(0..(k - 1), 0, fn i, acc -> acc + cell.(r + i, c + i) end)
      diag2 = Enum.reduce(0..(k - 1), 0, fn i, acc -> acc + cell.(r + k - 1 - i, c + i) end)
      diag1 == total and diag2 == total
    else
      false
    end
  end
end
