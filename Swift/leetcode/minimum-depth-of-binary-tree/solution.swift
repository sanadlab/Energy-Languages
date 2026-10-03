class Solution {
    func minDepth(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        var queue: [TreeNode] = [root]
        var idx = 0
        var depth = 1
        while idx < queue.count {
            let sz = queue.count - idx
            for _ in 0..<sz {
                let node = queue[idx]
                idx += 1
                if node.left == nil && node.right == nil { return depth }
                if let l = node.left { queue.append(l) }
                if let r = node.right { queue.append(r) }
            }
            depth += 1
        }
        return depth
    }
}
