// LC-energy test suite (Java) — cousins-in-binary-tree.
// Hand-written because TreeNode input needs a real helper (codegen
// skipped this cell). Builds tree [1,2,3,null,4,null,5] and calls
// isCousins(4, 5) — the cousins.
class TreeNode {
    int val;
    TreeNode left, right;
    TreeNode(int v) { val = v; }
}

public class TestSuite {
    public static void main(String[] args) {
        TreeNode root = new TreeNode(1);
        root.left  = new TreeNode(2); root.left.right  = new TreeNode(4);
        root.right = new TreeNode(3); root.right.right = new TreeNode(5);
        boolean result = new Solution().isCousins(root, 4, 5);
        if (!result) System.out.println("unexpected");
    }
}
