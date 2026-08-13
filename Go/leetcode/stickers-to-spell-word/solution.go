func minStickers(stickers []string, target string) int {
    n := len(target)
    full := (1 << n) - 1
    const INF = 1 << 30
    dp := make([]int, 1<<n)
    for i := range dp {
        dp[i] = INF
    }
    dp[0] = 0
    m := len(stickers)
    cnt := make([][26]int, m)
    for j := 0; j < m; j++ {
        for _, c := range stickers[j] {
            cnt[j][c-'a']++
        }
    }
    for state := 0; state <= full; state++ {
        if dp[state] == INF {
            continue
        }
        for j := 0; j < m; j++ {
            avail := cnt[j]
            nxt := state
            for i := 0; i < n; i++ {
                if state&(1<<i) == 0 {
                    c := int(target[i] - 'a')
                    if avail[c] > 0 {
                        avail[c]--
                        nxt |= 1 << i
                    }
                }
            }
            if dp[state]+1 < dp[nxt] {
                dp[nxt] = dp[state] + 1
            }
        }
    }
    if dp[full] == INF {
        return -1
    }
    return dp[full]
}
