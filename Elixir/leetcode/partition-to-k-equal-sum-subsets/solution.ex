defmodule Solution do
  import Bitwise

  @spec can_partition_k_subsets(nums :: [integer], k :: integer) :: boolean
  def can_partition_k_subsets(nums, k) do
    n = length(nums)

    cond do
      k <= 0 or n < k ->
        false

      true ->
        total = Enum.sum(nums)

        if rem(total, k) != 0 do
          false
        else
          target = div(total, k)
          tup = nums |> Enum.sort(:desc) |> List.to_tuple()

          if elem(tup, 0) > target do
            false
          else
            backtrack(tup, n, target, k, 0, 0, 0)
          end
        end
    end
  end

  # used is a bitmask of chosen indices
  defp backtrack(_tup, _n, _target, 0, _cur, _start, _used), do: true

  defp backtrack(tup, n, target, k, cur, start, used) do
    if cur == target do
      backtrack(tup, n, target, k - 1, 0, 0, used)
    else
      try_from(tup, n, target, k, cur, start, used)
    end
  end

  defp try_from(_tup, n, _target, _k, _cur, i, _used) when i >= n, do: false

  defp try_from(tup, n, target, k, cur, i, used) do
    bit = bsl(1, i)
    vi = elem(tup, i)

    if band(used, bit) != 0 or cur + vi > target do
      try_from(tup, n, target, k, cur, i + 1, used)
    else
      if backtrack(tup, n, target, k, cur + vi, i + 1, bor(used, bit)) do
        true
      else
        # equivalent to the reference's "if cur == 0: break"
        if cur == 0, do: false, else: try_from(tup, n, target, k, cur, i + 1, used)
      end
    end
  end
end
