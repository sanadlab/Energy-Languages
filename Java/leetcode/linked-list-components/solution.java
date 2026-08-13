import java.util.HashSet;
import java.util.Set;

class Solution {
    public int numComponents(ListNode head, int[] nums) {
        Set<Integer> set = new HashSet<>();
        for (int n : nums) set.add(n);
        int count = 0;
        boolean prev = false;
        while (head != null) {
            boolean cur = set.contains(head.val);
            if (cur && !prev) count++;
            prev = cur;
            head = head.next;
        }
        return count;
    }
}
