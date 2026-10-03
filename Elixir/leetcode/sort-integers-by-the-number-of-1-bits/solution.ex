defmodule Solution do
  @spec sort_by_bits(arr :: [integer]) :: [integer]
  def sort_by_bits(arr) do
    Enum.sort_by(arr, fn x -> {popcount(x, 0), x} end)
  end

  defp popcount(0, acc), do: acc
  defp popcount(x, acc), do: popcount(Bitwise.bsr(x, 1), acc + Bitwise.band(x, 1))
end
