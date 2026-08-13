public class Solution {
    public int NumComponents(ListNode head, int[] nums) {
        var set = new HashSet<int>(nums);
        int count = 0;
        bool prev = false;
        while (head != null) {
            bool cur = set.Contains(head.val);
            if (cur && !prev) count++;
            prev = cur;
            head = head.next;
        }
        return count;
    }
}
