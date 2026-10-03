defmodule Solution do
  import Bitwise

  @spec maximum_and_sum(nums :: [integer], num_slots :: integer) :: integer
  def maximum_and_sum(nums, num_slots) do
    n = length(nums)
    nums_t = List.to_tuple(nums)
    size = 1 <<< n
    full = size - 1

    # dp over subsets, stored as value+1 so 0 (the :atomics default) means the
    # mask is unreachable (the reference's dp[mask] == -1).
    dp = :atomics.new(size, signed: false)
    :atomics.put(dp, 1, 1)

    dp =
      Enum.reduce(1..num_slots, dp, fn slot, dp ->
        ndp = clone(dp, size)

        Enum.each(0..(size - 1), fn mask ->
          st = :atomics.get(dp, mask + 1)

          if st != 0 do
            base = st - 1
            assign_slot(nums_t, n, slot, mask, base, ndp)
          end
        end)

        ndp
      end)

    st = :atomics.get(dp, full + 1)
    if st == 0, do: 0, else: st - 1
  end

  defp assign_slot(nums_t, n, slot, mask, base, ndp) do
    Enum.each(0..(n - 1), fn i ->
      if (mask >>> i &&& 1) == 0 do
        nm = mask ||| 1 <<< i
        v = base + (elem(nums_t, i) &&& slot)
        relax(ndp, nm, v)

        Enum.each((i + 1)..(n - 1)//1, fn j ->
          if (mask >>> j &&& 1) == 0 do
            nm2 = nm ||| 1 <<< j
            v2 = v + (elem(nums_t, j) &&& slot)
            relax(ndp, nm2, v2)
          end
        end)
      end
    end)
  end

  defp relax(ndp, idx, v) do
    stored = v + 1
    if stored > :atomics.get(ndp, idx + 1), do: :atomics.put(ndp, idx + 1, stored)
    :ok
  end

  defp clone(src, size) do
    dst = :atomics.new(size, signed: false)
    Enum.each(1..size, fn i -> :atomics.put(dst, i, :atomics.get(src, i)) end)
    dst
  end
end
