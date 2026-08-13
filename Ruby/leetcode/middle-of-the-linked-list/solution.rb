# @param {ListNode} head
# @return {ListNode}
def middle_node(head)
  slow = head
  fast = head
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
  end
  slow
end
