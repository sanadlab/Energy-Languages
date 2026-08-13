package main

func maxScore(nums []int) int {
    m := len(nums)
    dp := make([]int, 1<<m)
    best := 0
    var gcd func(a, b int) int
    gcd = func(a, b int) int { for b != 0 { a, b = b, a%b }; return a }
    for mask := 0; mask < (1 << m); mask++ {
        cnt := 0
        for x := mask; x > 0; x >>= 1 { cnt += x & 1 }
        if cnt&1 == 1 { continue }
        op := cnt/2 + 1
        for i := 0; i < m; i++ {
            if (mask>>i)&1 == 1 { continue }
            for j := i + 1; j < m; j++ {
                if (mask>>j)&1 == 1 { continue }
                nm := mask | (1 << i) | (1 << j)
                val := dp[mask] + op*gcd(nums[i], nums[j])
                if val > dp[nm] { dp[nm] = val }
                if dp[nm] > best { best = dp[nm] }
            }
        }
    }
    return best
}
