defmodule Solution do
  @spec max_sum_two_no_overlap(nums :: [integer], first_len :: integer, second_len :: integer) :: integer
  def max_sum_two_no_overlap(nums, first_len, second_len) do
    n = length(nums)
    pre = prefix(nums)
    max(best(pre, n, first_len, second_len), best(pre, n, second_len, first_len))
  end

  defp prefix(nums) do
    {_, acc} =
      Enum.reduce(nums, {0, [0]}, fn x, {sum, acc} ->
        s = sum + x
        {s, [s | acc]}
      end)

    acc |> Enum.reverse() |> List.to_tuple()
  end

  defp best(pre, n, l, m) do
    {res, _maxl} =
      Enum.reduce((l + m)..n//1, {0, 0}, fn i, {res, maxl} ->
        maxl = max(maxl, elem(pre, i - m) - elem(pre, i - m - l))
        res = max(res, maxl + elem(pre, i) - elem(pre, i - m))
        {res, maxl}
      end)

    res
  end
end
