func minSteps(n int) int {
    if n == 1 { return 0 }
    ans, d := 0, 2
    for n > 1 {
        for n % d == 0 { ans += d; n /= d }
        d++
    }
    return ans
}
