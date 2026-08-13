// LC-energy test suite (Java) — linked-list-components.
class ListNode {
    int val; ListNode next;
    ListNode(int v) { val = v; }
}

public class TestSuite {
    public static void main(String[] args) {
        ListNode h = new ListNode(0);
        h.next = new ListNode(1); h.next.next = new ListNode(2); h.next.next.next = new ListNode(3);
        int r = new Solution().numComponents(h, new int[]{0, 1, 3});
        if (r < 0) System.out.println(r);
    }
}
