func maxSizeSlices(slices []int) int {
    total := len(slices)
    k := total / 3
    if k == 0 {
        return 0
    }
    a := slices[:total-1]
    b := slices[1:]
    r1 := pizzaBest(a, k)
    r2 := pizzaBest(b, k)
    if r1 > r2 {
        return r1
    }
    return r2
}

func pizzaBest(nums []int, k int) int {
    n := len(nums)
    const NEG = -(1 << 60)
    dp := make([][]int, n+1)
    for i := range dp {
        dp[i] = make([]int, k+1)
        for j := 1; j <= k; j++ {
            dp[i][j] = NEG
        }
    }
    for i := 1; i <= n; i++ {
        for j := 1; j <= k; j++ {
            skip := dp[i-1][j]
            var prev int
            if i >= 2 {
                prev = dp[i-2][j-1]
            } else if j == 1 {
                prev = 0
            } else {
                prev = NEG
            }
            take := prev + nums[i-1]
            if skip > take {
                dp[i][j] = skip
            } else {
                dp[i][j] = take
            }
        }
    }
    return dp[n][k]
}
