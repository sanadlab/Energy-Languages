class Solution {
    func minStickers(_ stickers: [String], _ target: String) -> Int {
        let targetChars = Array(target)
        let n = targetChars.count
        let full = (1 << n) - 1
        let INF = Int.max
        var dp = [Int](repeating: INF, count: 1 << n)
        dp[0] = 0
        let aVal = Int(Character("a").asciiValue!)
        var cnt = [[Int]]()
        for s in stickers {
            var c = [Int](repeating: 0, count: 26)
            for ch in s {
                c[Int(ch.asciiValue!) - aVal] += 1
            }
            cnt.append(c)
        }
        let targetIdx = targetChars.map { Int($0.asciiValue!) - aVal }
        for state in 0..<(1 << n) {
            if dp[state] == INF { continue }
            for c in cnt {
                var avail = c
                var nxt = state
                for i in 0..<n {
                    if (state & (1 << i)) == 0 {
                        let idx = targetIdx[i]
                        if avail[idx] > 0 {
                            avail[idx] -= 1
                            nxt |= (1 << i)
                        }
                    }
                }
                if dp[state] + 1 < dp[nxt] {
                    dp[nxt] = dp[state] + 1
                }
            }
        }
        return dp[full] == INF ? -1 : dp[full]
    }
}
