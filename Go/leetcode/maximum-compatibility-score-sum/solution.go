func maxCompatibilitySum(students [][]int, mentors [][]int) int {
    m := len(students)
    n := 0
    if m > 0 { n = len(students[0]) }
    score := make([][]int, m)
    for i := 0; i < m; i++ {
        score[i] = make([]int, m)
        for j := 0; j < m; j++ {
            for k := 0; k < n; k++ {
                if students[i][k] == mentors[j][k] { score[i][j]++ }
            }
        }
    }
    dp := make([]int, 1<<m)
    for mask := 0; mask < (1 << m); mask++ {
        cnt := 0
        for x := mask; x > 0; x >>= 1 { cnt += x & 1 }
        if cnt >= m { continue }
        for j := 0; j < m; j++ {
            if (mask>>j)&1 == 1 { continue }
            nm := mask | (1 << j)
            val := dp[mask] + score[cnt][j]
            if val > dp[nm] { dp[nm] = val }
        }
    }
    return dp[(1<<m)-1]
}
