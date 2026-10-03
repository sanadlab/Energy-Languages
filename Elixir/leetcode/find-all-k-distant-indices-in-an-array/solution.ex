defmodule Solution do
  @spec find_k_distant_indices(nums :: [integer], key :: integer, k :: integer) :: [integer]
  def find_k_distant_indices(nums, key, k) do
    t = List.to_tuple(nums)
    n = tuple_size(t)

    for i <- 0..(n - 1),
        Enum.any?(0..(n - 1), fn j -> abs(i - j) <= k and elem(t, j) == key end) do
      i
    end
  end
end
