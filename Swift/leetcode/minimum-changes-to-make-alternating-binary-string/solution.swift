class Solution {
    func minOperations(_ s: String) -> Int {
        let chars = Array(s)
        let n = chars.count
        var cnt = 0
        for i in 0..<n {
            let expected: Character = (i % 2 == 0) ? "0" : "1"
            if chars[i] != expected {
                cnt += 1
            }
        }
        return min(cnt, n - cnt)
    }
}
