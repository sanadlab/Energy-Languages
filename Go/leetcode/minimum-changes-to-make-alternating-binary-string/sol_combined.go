package main

func minOperations(s string) int {
    cnt, n := 0, len(s)
    for i := 0; i < n; i++ {
        var expected byte = '0'
        if i%2 == 1 {
            expected = '1'
        }
        if s[i] != expected {
            cnt++
        }
    }
    if cnt < n-cnt {
        return cnt
    }
    return n - cnt
}
