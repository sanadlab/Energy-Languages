defmodule Solution do
  @spec min_days(bloom_day :: [integer], m :: integer, k :: integer) :: integer
  def min_days(bloom_day, m, k) do
    if m * k > length(bloom_day) do
      -1
    else
      search(bloom_day, m, k, Enum.min(bloom_day), Enum.max(bloom_day))
    end
  end

  defp search(_bloom_day, _m, _k, lo, hi) when lo >= hi, do: lo

  defp search(bloom_day, m, k, lo, hi) do
    mid = div(lo + hi, 2)

    if can_make(bloom_day, k, mid) >= m do
      search(bloom_day, m, k, lo, mid)
    else
      search(bloom_day, m, k, mid + 1, hi)
    end
  end

  defp can_make(bloom_day, k, day) do
    {bouquets, _flowers} =
      Enum.reduce(bloom_day, {0, 0}, fn b, {bouquets, flowers} ->
        if b <= day do
          flowers = flowers + 1
          if flowers == k, do: {bouquets + 1, 0}, else: {bouquets, flowers}
        else
          {bouquets, 0}
        end
      end)

    bouquets
  end
end
