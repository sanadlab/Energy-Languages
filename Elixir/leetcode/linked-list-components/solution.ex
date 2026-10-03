defmodule Solution do
  @spec num_components(head :: ListNode.t | nil, nums :: [integer]) :: integer
  def num_components(head, nums) do
    set = MapSet.new(nums)
    count(head, set, false, 0)
  end

  defp count(nil, _set, _prev, acc), do: acc

  defp count(%ListNode{val: v, next: next}, set, prev, acc) do
    cur = MapSet.member?(set, v)
    acc = if cur and not prev, do: acc + 1, else: acc
    count(next, set, cur, acc)
  end
end
