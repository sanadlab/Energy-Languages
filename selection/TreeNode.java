// Shared public node type for the JVM harness (Java + Kotlin cells). Public so a
// Kotlin `fun f(root: TreeNode?)` can expose it; LeetCode-style int `val` field.
public class TreeNode { public int val; public TreeNode left, right; public TreeNode(int v){ val=v; } }
