defmodule Solution do
  @spec k_weakest_rows(mat :: [[integer]], k :: integer) :: [integer]
  def k_weakest_rows(mat, k) do
    mat
    |> Enum.with_index()
    |> Enum.map(fn {row, i} -> {Enum.sum(row), i} end)
    |> Enum.sort()
    |> Enum.take(k)
    |> Enum.map(fn {_cnt, i} -> i end)
  end
end
