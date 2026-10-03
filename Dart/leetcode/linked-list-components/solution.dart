class Solution {
  int numComponents(ListNode? head, List<int> nums) {
    final Set<int> set = <int>{};
    for (final n in nums) {
      set.add(n);
    }
    int count = 0;
    bool prev = false;
    ListNode? node = head;
    while (node != null) {
      final bool cur = set.contains(node.val);
      if (cur && !prev) count++;
      prev = cur;
      node = node.next;
    }
    return count;
  }
}
