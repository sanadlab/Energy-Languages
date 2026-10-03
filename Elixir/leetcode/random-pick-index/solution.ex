defmodule Solution do
  @spec init_(nums :: [integer]) :: any
  def init_(nums) do
    Process.put(:rpi_nums, nums)
    :ok
  end

  @spec pick(target :: integer) :: integer
  def pick(target) do
    # Full reservoir sampling: scan the WHOLE array, rolling the RNG on each
    # match so every matching index has equal probability.
    {_count, res} =
      Process.get(:rpi_nums)
      |> Enum.with_index()
      |> Enum.reduce({0, -1}, fn {x, i}, {count, res} ->
        if x == target do
          count = count + 1
          if :rand.uniform(count) == 1, do: {count, i}, else: {count, res}
        else
          {count, res}
        end
      end)

    res
  end
end

# Your functions will be called as such:
# Solution.init_(nums)
# param_1 = Solution.pick(target)

# Solution.init_ will be called before every test case, in which you can do some necessary initializations.
