class Solution {
    func friendRequests(_ n: Int, _ restrictions: [[Int]], _ requests: [[Int]]) -> [Bool] {
        var parent = Array(0..<n)
        func find(_ x0: Int) -> Int {
            var x = x0
            while parent[x] != x {
                parent[x] = parent[parent[x]]
                x = parent[x]
            }
            return x
        }
        var res: [Bool] = []
        for req in requests {
            let u = req[0]
            let v = req[1]
            let pu = find(u)
            let pv = find(v)
            if pu == pv {
                res.append(true)
                continue
            }
            var ok = true
            for r in restrictions {
                let px = find(r[0])
                let py = find(r[1])
                if (px == pu && py == pv) || (px == pv && py == pu) {
                    ok = false
                    break
                }
            }
            if ok {
                parent[pu] = pv
                res.append(true)
            } else {
                res.append(false)
            }
        }
        return res
    }
}
