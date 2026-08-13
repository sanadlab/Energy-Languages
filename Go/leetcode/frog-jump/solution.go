func canCross(stones []int) bool {
    n := len(stones)
    if n == 0 {
        return false
    }
    // Map stone position to its index for quick lookup
    posIndex := make(map[int]int, n)
    for i, stone := range stones {
        posIndex[stone] = i
    }

    // dp[i] stores a set of jump sizes that can land on stones[i]
    dp := make([]map[int]struct{}, n)
    for i := range dp {
        dp[i] = make(map[int]struct{})
    }
    // The first jump must be 1 unit
    dp[0][0] = struct{}{} // starting point, jump size 0

    for i := 0; i < n; i++ {
        for k := range dp[i] {
            for step := k - 1; step <= k+1; step++ {
                if step > 0 {
                    nextPos := stones[i] + step
                    if j, ok := posIndex[nextPos]; ok {
                        dp[j][step] = struct{}{}
                    }
                }
            }
        }
    }

    return len(dp[n-1]) > 0
}