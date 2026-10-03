defmodule Solution do
  @spec maximum_beauty(flowers :: [integer], new_flowers :: integer, target :: integer, full :: integer, partial :: integer) :: integer
  def maximum_beauty(flowers, new_flowers, target, full, partial) do
    n = length(flowers)

    if n == 0 do
      0
    else
      fl_list = flowers |> Enum.map(&min(&1, target)) |> Enum.sort()
      fl = List.to_tuple(fl_list)

      {pre_rev, _} =
        Enum.reduce(fl_list, {[0], 0}, fn x, {acc, s} ->
          s2 = s + x
          {[s2 | acc], s2}
        end)

      pre = pre_rev |> Enum.reverse() |> List.to_tuple()
      total = elem(pre, n)

      if elem(fl, 0) == target do
        full * n
      else
        Enum.reduce(n..0//-1, 0, fn i, ans ->
          cost_complete = target * (n - i) - (total - elem(pre, i))

          cond do
            cost_complete > new_flowers ->
              ans

            i == 0 ->
              max(ans, full * (n - i))

            true ->
              budget = new_flowers - cost_complete
              best_min = do_search(fl, pre, i, 0, target - 1, 0, budget)
              max(ans, full * (n - i) + best_min * partial)
          end
        end)
      end
    end
  end

  defp do_search(_fl, _pre, _i, lo, hi, best, _budget) when lo > hi, do: best

  defp do_search(fl, pre, i, lo, hi, best, budget) do
    v = div(lo + hi, 2)
    k = bisect_left(fl, v, 0, i)
    cost = v * k - elem(pre, k)

    if cost <= budget do
      do_search(fl, pre, i, v + 1, hi, v, budget)
    else
      do_search(fl, pre, i, lo, v - 1, best, budget)
    end
  end

  # leftmost index in [lo, hi) of an element >= v (count of elements < v).
  defp bisect_left(_fl, _v, lo, hi) when lo >= hi, do: lo

  defp bisect_left(fl, v, lo, hi) do
    mid = div(lo + hi, 2)
    if elem(fl, mid) < v, do: bisect_left(fl, v, mid + 1, hi), else: bisect_left(fl, v, lo, mid)
  end
end
