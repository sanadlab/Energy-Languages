func nextBeautifulNumber(n int) int {
    for x := n + 1; ; x++ {
        var cnt [10]int
        t := x
        for t > 0 {
            cnt[t%10]++
            t /= 10
        }
        ok := true
        for d := 0; d < 10; d++ {
            if cnt[d] != 0 && cnt[d] != d {
                ok = false
                break
            }
        }
        if ok {
            return x
        }
    }
}
