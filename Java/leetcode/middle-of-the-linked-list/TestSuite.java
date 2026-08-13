// LC-energy test suite (Java) — middle-of-the-linked-list.
class ListNode {
    int val; ListNode next;
    ListNode(int v) { val = v; }
}

public class TestSuite {
    public static void main(String[] args) {
        ListNode h = new ListNode(1); ListNode c = h;
        for (int v : new int[]{2, 3, 4, 5}) { c.next = new ListNode(v); c = c.next; }
        ListNode r = new Solution().middleNode(h);
        if (r == null) System.out.println("unexpected");
    }
}
