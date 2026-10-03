defmodule Solution do
  @spec min_start_value(nums :: [integer]) :: integer
  def min_start_value(nums) do
    {_prefix, min_prefix} =
      Enum.reduce(nums, {0, 0}, fn x, {prefix, min_prefix} ->
        prefix = prefix + x
        {prefix, min(min_prefix, prefix)}
      end)

    max(1, 1 - min_prefix)
  end
end
