// LC-energy test suite (C#) — cousins-in-binary-tree.
// TreeNode helper + main entry point in the same file so we don't need
// a separate wrapper class.
public class TreeNode {
    public int val;
    public TreeNode left, right;
    public TreeNode(int v) { val = v; }
}

public class TestSuite {
    public static void Main() {
        var root = new TreeNode(1);
        root.left  = new TreeNode(2); root.left.right  = new TreeNode(4);
        root.right = new TreeNode(3); root.right.right = new TreeNode(5);
        var r = new Solution().IsCousins(root, 4, 5);
        if (!r) System.Console.WriteLine("unexpected");
    }
}
