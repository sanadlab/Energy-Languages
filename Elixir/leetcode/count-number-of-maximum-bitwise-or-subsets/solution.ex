defmodule Solution do
  import Bitwise

  @spec count_max_or_subsets(nums :: [integer]) :: integer
  def count_max_or_subsets(nums) do
    tup = List.to_tuple(nums)
    n = tuple_size(tup)
    max_or = Enum.reduce(nums, 0, fn num, acc -> bor(acc, num) end)

    Enum.reduce(1..(bsl(1, n) - 1), 0, fn mask, count ->
      cur =
        Enum.reduce(0..(n - 1), 0, fn i, acc ->
          if band(mask, bsl(1, i)) != 0, do: bor(acc, elem(tup, i)), else: acc
        end)

      if cur == max_or, do: count + 1, else: count
    end)
  end
end
