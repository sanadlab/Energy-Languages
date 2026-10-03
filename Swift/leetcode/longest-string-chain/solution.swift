class Solution {
    func longestStrChain(_ words: [String]) -> Int {
        let ordered = words.sorted { $0.count < $1.count }
        var dp = [String: Int]()
        var best = 1
        for w in ordered {
            let chars = Array(w)
            var cur = 1
            for i in 0..<chars.count {
                var pred = chars
                pred.remove(at: i)
                if let v = dp[String(pred)] { cur = max(cur, v + 1) }
            }
            dp[w] = cur
            best = max(best, cur)
        }
        return best
    }
}
