// LC-energy test suite (Java) — TreeNode single case.
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode() {}
    TreeNode(int val) { this.val = val; }
    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}
public class TestSuite {
    public static void main(String[] args) {
        TreeNode root = new TreeNode(3, new TreeNode(9),
            new TreeNode(20, new TreeNode(15), new TreeNode(7)));
        Solution sol = new Solution();
        int result = sol.minDepth(root);
        if (result < 0) System.out.println(result);
    }
}
