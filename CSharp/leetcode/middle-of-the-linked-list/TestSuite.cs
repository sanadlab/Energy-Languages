// LC-energy test suite (C#) — middle-of-the-linked-list.
public class ListNode {
    public int val;
    public ListNode next;
    public ListNode(int v) { val = v; }
}

public class TestSuite {
    public static void Main() {
        var h = new ListNode(1); var c = h;
        foreach (var v in new int[]{2,3,4,5}) { c.next = new ListNode(v); c = c.next; }
        var r = new Solution().MiddleNode(h);
        if (r == null) System.Console.WriteLine("unexpected");
    }
}
