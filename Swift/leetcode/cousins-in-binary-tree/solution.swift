class Solution {
    func isCousins(_ root: TreeNode?, _ x: Int, _ y: Int) -> Bool {
        var dx = -1, dy = -1; var px: TreeNode? = nil, py: TreeNode? = nil
        func dfs(_ n: TreeNode?, _ p: TreeNode?, _ d: Int) {
            guard let n = n else { return }
            if n.val == x { dx = d; px = p }
            if n.val == y { dy = d; py = p }
            dfs(n.left, n, d+1); dfs(n.right, n, d+1)
        }
        dfs(root, nil, 0)
        return dx == dy && px !== py
    }
}
