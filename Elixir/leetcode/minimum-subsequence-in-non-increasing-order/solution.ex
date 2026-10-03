defmodule Solution do
  @spec min_subsequence(nums :: [integer]) :: [integer]
  def min_subsequence(nums) do
    sorted = Enum.sort(nums, :desc)
    total = Enum.sum(sorted)

    {res, _running} =
      Enum.reduce_while(sorted, {[], 0}, fn x, {acc, running} ->
        running = running + x
        acc = [x | acc]

        if running * 2 > total do
          {:halt, {acc, running}}
        else
          {:cont, {acc, running}}
        end
      end)

    Enum.reverse(res)
  end
end
