defmodule Solution do
  @spec length_of_lis(nums :: [integer]) :: integer
  def length_of_lis(nums) do
    {_tails, len} =
      Enum.reduce(nums, {%{}, 0}, fn x, {tails, len} ->
        i = bisect_left(tails, len, x)
        {Map.put(tails, i, x), max(len, i + 1)}
      end)

    len
  end

  # leftmost index i in [0, len) with tails[i] >= x (bisect_left)
  defp bisect_left(tails, len, x), do: bl(tails, 0, len, x)

  defp bl(_tails, lo, hi, _x) when lo >= hi, do: lo

  defp bl(tails, lo, hi, x) do
    mid = div(lo + hi, 2)

    if Map.get(tails, mid) < x do
      bl(tails, mid + 1, hi, x)
    else
      bl(tails, lo, mid, x)
    end
  end
end
