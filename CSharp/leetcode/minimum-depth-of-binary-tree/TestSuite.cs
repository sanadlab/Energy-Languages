// LC-energy test suite (C#) — TreeNode single case.
public class TreeNode {
    public int val;
    public TreeNode left;
    public TreeNode right;
    public TreeNode(int val=0, TreeNode left=null, TreeNode right=null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}
public class TestSuite {
    public static void Main() {
        TreeNode root = new TreeNode(3, new TreeNode(9),
            new TreeNode(20, new TreeNode(15), new TreeNode(7)));
        var sol = new Solution();
        var result = sol.MinDepth(root);
        if (result < 0) System.Console.WriteLine(result);
    }
}
