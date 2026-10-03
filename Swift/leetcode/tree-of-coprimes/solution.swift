class Solution {
    func getCoprimes(_ nums: [Int], _ edges: [[Int]]) -> [Int] {
        let n = nums.count
        var ans = [Int](repeating: -1, count: n)
        if n == 0 {
            return ans
        }
        var adj = [[Int]](repeating: [Int](), count: n)
        for e in edges {
            if e.count < 2 {
                continue
            }
            let u = e[0]
            let v = e[1]
            if u >= 0 && u < n && v >= 0 && v < n {
                adj[u].append(v)
                adj[v].append(u)
            }
        }
        func gcd(_ a: Int, _ b: Int) -> Int {
            var x = a
            var y = b
            while y != 0 {
                let t = x % y
                x = y
                y = t
            }
            return x
        }
        var coprime = [[Int]](repeating: [Int](), count: 51)
        for a in 1...50 {
            for b in 1...50 {
                if gcd(a, b) == 1 {
                    coprime[a].append(b)
                }
            }
        }
        var depthStack = [[Int]](repeating: [Int](), count: 51)
        var nodeStack = [[Int]](repeating: [Int](), count: 51)
        var stack: [(Int, Int, Int, Bool)] = [(0, -1, 0, false)]
        while !stack.isEmpty {
            let (node, parent, depth, processed) = stack.removeLast()
            let val = nums[node]
            if processed {
                depthStack[val].removeLast()
                nodeStack[val].removeLast()
                continue
            }
            var bestDepth = -1
            var bestNode = -1
            for cv in coprime[val] {
                if let last = depthStack[cv].last, last > bestDepth {
                    bestDepth = last
                    bestNode = nodeStack[cv].last!
                }
            }
            ans[node] = bestNode
            stack.append((node, parent, depth, true))
            depthStack[val].append(depth)
            nodeStack[val].append(node)
            for nb in adj[node] {
                if nb != parent {
                    stack.append((nb, node, depth + 1, false))
                }
            }
        }
        return ans
    }
}
