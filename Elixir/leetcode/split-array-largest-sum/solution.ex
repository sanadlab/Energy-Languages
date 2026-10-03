defmodule Solution do
  @spec split_array(nums :: [integer], k :: integer) :: integer
  def split_array(nums, k) do
    bsearch(nums, k, Enum.max(nums), Enum.sum(nums))
  end

  defp bsearch(_nums, _k, lo, hi) when lo >= hi, do: lo

  defp bsearch(nums, k, lo, hi) do
    mid = div(lo + hi, 2)

    if count_splits(nums, mid) <= k do
      bsearch(nums, k, lo, mid)
    else
      bsearch(nums, k, mid + 1, hi)
    end
  end

  defp count_splits(nums, mid) do
    {cnt, _cur} =
      Enum.reduce(nums, {1, 0}, fn x, {cnt, cur} ->
        if cur + x > mid, do: {cnt + 1, x}, else: {cnt, cur + x}
      end)

    cnt
  end
end
