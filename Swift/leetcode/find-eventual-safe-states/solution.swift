class Solution {
    func eventualSafeNodes(_ graph: [[Int]]) -> [Int] {
        let n = graph.count
        var rev = [[Int]](repeating: [], count: n)
        var outdeg = [Int](repeating: 0, count: n)
        for u in 0..<n {
            for v in graph[u] {
                if v >= 0 && v < n {
                    rev[v].append(u)
                    outdeg[u] += 1
                }
            }
        }
        var q = [Int]()
        for i in 0..<n {
            if outdeg[i] == 0 {
                q.append(i)
            }
        }
        var safe = [Bool](repeating: false, count: n)
        var head = 0
        while head < q.count {
            let v = q[head]
            head += 1
            safe[v] = true
            for u in rev[v] {
                outdeg[u] -= 1
                if outdeg[u] == 0 {
                    q.append(u)
                }
            }
        }
        var res = [Int]()
        for i in 0..<n {
            if safe[i] {
                res.append(i)
            }
        }
        return res
    }
}
