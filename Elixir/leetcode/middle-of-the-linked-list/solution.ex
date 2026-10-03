defmodule Solution do
  @spec middle_node(head :: ListNode.t | nil) :: ListNode.t | nil
  def middle_node(head), do: mid(head, head)

  defp mid(slow, fast) do
    cond do
      fast == nil -> slow
      fast.next == nil -> slow
      true -> mid(slow.next, fast.next.next)
    end
  end
end
