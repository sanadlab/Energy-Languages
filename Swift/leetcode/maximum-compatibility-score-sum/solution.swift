class Solution {
    func maxCompatibilitySum(_ students: [[Int]], _ mentors: [[Int]]) -> Int {
        let m = students.count
        let n = m > 0 ? students[0].count : 0
        var score = [[Int]](repeating: [Int](repeating: 0, count: m), count: m)
        for i in 0..<m {
            for j in 0..<m {
                var s = 0
                for k in 0..<n {
                    if students[i][k] == mentors[j][k] { s += 1 }
                }
                score[i][j] = s
            }
        }
        var dp = [Int](repeating: 0, count: 1 << m)
        for mask in 0..<(1 << m) {
            let i = mask.nonzeroBitCount
            if i >= m { continue }
            for j in 0..<m {
                if (mask >> j) & 1 == 1 { continue }
                let nm = mask | (1 << j)
                let val = dp[mask] + score[i][j]
                if val > dp[nm] { dp[nm] = val }
            }
        }
        return dp[(1 << m) - 1]
    }
}
