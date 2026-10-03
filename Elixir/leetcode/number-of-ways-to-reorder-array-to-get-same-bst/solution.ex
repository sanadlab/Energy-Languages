defmodule Solution do
  @spec num_of_ways(nums :: [integer]) :: integer
  def num_of_ways(nums) do
    mod = 1_000_000_007
    n = length(nums)
    cc = build_pascal(n, mod)
    rem(ways(nums, cc, mod) - 1, mod)
  end

  # cc[i][j] = C(i, j) mod MOD, as a tuple of row tuples (size n+1 each).
  defp build_pascal(n, mod) do
    rows =
      Enum.reduce(0..n//1, [], fn i, acc ->
        prev =
          case acc do
            [] -> nil
            [h | _] -> h
          end

        row = build_row(i, n, prev, mod)
        [row | acc]
      end)

    rows |> Enum.reverse() |> List.to_tuple()
  end

  defp build_row(i, n, prev, mod) do
    for j <- 0..n//1 do
      cond do
        j == 0 -> 1
        j > i -> 0
        true -> rem(elem(prev, j - 1) + elem(prev, j), mod)
      end
    end
    |> List.to_tuple()
  end

  defp ways(arr, cc, mod) do
    m = length(arr)

    if m <= 2 do
      1
    else
      [root | rest] = arr
      left = Enum.filter(rest, &(&1 < root))
      right = Enum.filter(rest, &(&1 > root))
      crow = elem(cc, m - 1)

      acc = rem(elem(crow, length(left)) * ways(left, cc, mod), mod)
      acc = acc * ways(right, cc, mod)
      rem(acc, mod)
    end
  end
end
