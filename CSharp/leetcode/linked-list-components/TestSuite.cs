// LC-energy test suite (C#) — linked-list-components.
public class ListNode {
    public int val;
    public ListNode next;
    public ListNode(int v) { val = v; }
}

public class TestSuite {
    public static void Main() {
        var h = new ListNode(0);
        h.next = new ListNode(1); h.next.next = new ListNode(2); h.next.next.next = new ListNode(3);
        var r = new Solution().NumComponents(h, new int[]{0, 1, 3});
        if (r < 0) System.Console.WriteLine(r);
    }
}
