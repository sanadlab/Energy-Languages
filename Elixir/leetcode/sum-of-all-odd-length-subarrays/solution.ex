defmodule Solution do
  @spec sum_odd_length_subarrays(arr :: [integer]) :: integer
  def sum_odd_length_subarrays(arr) do
    tup = List.to_tuple(arr)
    n = tuple_size(tup)

    Enum.reduce(0..(n - 1), 0, fn i, total ->
      count = div((i + 1) * (n - i) + 1, 2)
      total + count * elem(tup, i)
    end)
  end
end
