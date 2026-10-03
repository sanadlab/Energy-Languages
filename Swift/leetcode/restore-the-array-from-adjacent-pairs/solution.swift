class Solution {
    func restoreArray(_ adjacentPairs: [[Int]]) -> [Int] {
        var adj = [Int: [Int]]()
        var order = [Int]()
        for pair in adjacentPairs {
            let u = pair[0], v = pair[1]
            if adj[u] == nil {
                order.append(u)
                adj[u] = []
            }
            adj[u]!.append(v)
            if adj[v] == nil {
                order.append(v)
                adj[v] = []
            }
            adj[v]!.append(u)
        }
        let n = adjacentPairs.count + 1
        var start = adjacentPairs.isEmpty ? 0 : adjacentPairs[0][0]
        for node in order {
            if adj[node]!.count == 1 {
                start = node
                break
            }
        }
        var res = [start]
        var prev = start
        var cur = start
        var hasPrev = false
        while res.count < n {
            var nxt: Int? = nil
            for x in adj[cur]! {
                if !hasPrev || x != prev {
                    nxt = x
                    break
                }
            }
            guard let next = nxt else { break }
            res.append(next)
            prev = cur
            hasPrev = true
            cur = next
        }
        return res
    }
}
