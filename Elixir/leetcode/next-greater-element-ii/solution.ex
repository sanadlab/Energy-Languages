defmodule Solution do
  @spec next_greater_elements(nums :: [integer]) :: [integer]
  def next_greater_elements(nums) do
    arr = List.to_tuple(nums)
    n = tuple_size(arr)

    if n == 0 do
      []
    else
      res = loop(arr, n, 0, 2 * n, [], %{})
      for i <- 0..(n - 1), do: Map.get(res, i, -1)
    end
  end

  defp loop(_arr, _n, i, limit, _stack, res) when i >= limit, do: res
  defp loop(arr, n, i, limit, stack, res) do
    cur = elem(arr, rem(i, n))
    {stack, res} = pop_smaller(arr, stack, cur, res)
    stack = if i < n, do: [i | stack], else: stack
    loop(arr, n, i + 1, limit, stack, res)
  end

  defp pop_smaller(arr, [top | rest], cur, res) do
    if elem(arr, top) < cur do
      pop_smaller(arr, rest, cur, Map.put(res, top, cur))
    else
      {[top | rest], res}
    end
  end
  defp pop_smaller(_arr, [], _cur, res), do: {[], res}
end
