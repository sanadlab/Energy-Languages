class Solution {
    func validateBinaryTreeNodes(_ n: Int, _ leftChild: [Int], _ rightChild: [Int]) -> Bool {
        let m = min(leftChild.count, rightChild.count)
        var indeg = [Int](repeating: 0, count: n)
        for i in 0..<m {
            for c in [leftChild[i], rightChild[i]] {
                if c != -1 {
                    if c < 0 || c >= n {
                        return false
                    }
                    indeg[c] += 1
                    if indeg[c] > 1 {
                        return false
                    }
                }
            }
        }
        var root = -1
        for i in 0..<n {
            if indeg[i] == 0 {
                if root != -1 {
                    return false
                }
                root = i
            }
        }
        if root == -1 {
            return false
        }
        var visited = [Bool](repeating: false, count: n)
        var stack = [root]
        var count = 0
        while let node = stack.popLast() {
            if visited[node] {
                return false
            }
            visited[node] = true
            count += 1
            if node < m {
                for c in [leftChild[node], rightChild[node]] {
                    if c != -1 {
                        stack.append(c)
                    }
                }
            }
        }
        return count == n
    }
}
