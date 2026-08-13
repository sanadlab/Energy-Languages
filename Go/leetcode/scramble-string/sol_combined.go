package main

func isScramble(s1 string, s2 string) bool {
    if len(s1) != len(s2) {
        return false
    }
    memo := make(map[string]bool)
    sortedEqual := func(a, b string) bool {
        var c [26]int
        for i := 0; i < len(a); i++ {
            c[a[i]-'a']++
            c[b[i]-'a']--
        }
        for _, v := range c {
            if v != 0 {
                return false
            }
        }
        return true
    }
    var helper func(a, b string) bool
    helper = func(a, b string) bool {
        if a == b {
            return true
        }
        key := a + "#" + b
        if v, ok := memo[key]; ok {
            return v
        }
        if !sortedEqual(a, b) {
            memo[key] = false
            return false
        }
        n := len(a)
        res := false
        for i := 1; i < n; i++ {
            if helper(a[:i], b[:i]) && helper(a[i:], b[i:]) {
                res = true
                break
            }
            if helper(a[:i], b[n-i:]) && helper(a[i:], b[:n-i]) {
                res = true
                break
            }
        }
        memo[key] = res
        return res
    }
    return helper(s1, s2)
}
