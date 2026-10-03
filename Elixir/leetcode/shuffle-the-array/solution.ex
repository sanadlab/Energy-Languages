defmodule Solution do
  @spec shuffle(nums :: [integer], n :: integer) :: [integer]
  def shuffle(nums, _n) do
    m = div(length(nums), 2)
    t = List.to_tuple(nums)
    Enum.flat_map(0..(m - 1)//1, fn i -> [elem(t, i), elem(t, i + m)] end)
  end
end
