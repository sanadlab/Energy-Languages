class Solution {
    func minSessions(_ tasks: [Int], _ sessionTime: Int) -> Int {
        let n = tasks.count
        let full = (1 << n) - 1
        let INF = Int.max
        var sessions = [Int](repeating: INF, count: 1 << n)
        var used = [Int](repeating: 0, count: 1 << n)
        sessions[0] = 1
        for mask in 0...full {
            if sessions[mask] == INF {
                continue
            }
            for i in 0..<n {
                if mask & (1 << i) != 0 {
                    continue
                }
                let nm = mask | (1 << i)
                let ns: Int
                let nu: Int
                if used[mask] + tasks[i] <= sessionTime {
                    ns = sessions[mask]
                    nu = used[mask] + tasks[i]
                } else {
                    ns = sessions[mask] + 1
                    nu = tasks[i]
                }
                if ns < sessions[nm] || (ns == sessions[nm] && nu < used[nm]) {
                    sessions[nm] = ns
                    used[nm] = nu
                }
            }
        }
        return sessions[full]
    }
}
