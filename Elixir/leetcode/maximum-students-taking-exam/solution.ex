defmodule Solution do
  import Bitwise

  @spec max_students(seats :: [[char]]) :: integer
  def max_students(seats) do
    m = length(seats)

    if m == 0 do
      0
    else
      n = length(hd(seats))
      full = 1 <<< n
      avail = seats |> Enum.map(&row_mask(&1, n)) |> List.to_tuple()

      final =
        Enum.reduce(0..(m - 1)//1, %{0 => 0}, fn i, best ->
          av = elem(avail, i)

          Enum.reduce(0..(full - 1), %{}, fn mask, ndp ->
            cond do
              band(mask, av) != mask ->
                ndp

              band(mask, bsl(mask, 1)) != 0 ->
                ndp

              true ->
                pc = popcount(mask)

                bv =
                  Enum.reduce(best, -1, fn {pmask, pval}, acc ->
                    cond do
                      band(mask, bsl(pmask, 1)) != 0 -> acc
                      band(mask, bsr(pmask, 1)) != 0 -> acc
                      true -> max(acc, pval + pc)
                    end
                  end)

                if bv >= 0, do: Map.put(ndp, mask, bv), else: ndp
            end
          end)
        end)

      final |> Map.values() |> Enum.max()
    end
  end

  defp row_mask(row, n) do
    row
    |> Enum.take(n)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {cell, j}, acc ->
      if cell == ".", do: bor(acc, bsl(1, j)), else: acc
    end)
  end

  defp popcount(0), do: 0
  defp popcount(x), do: band(x, 1) + popcount(bsr(x, 1))
end
