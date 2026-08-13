package main

func minDays(n int) int {
    memo := map[int]int{}
    var solve func(x int) int
    solve = func(x int) int {
        if x <= 1 {
            return x
        }
        if v, ok := memo[x]; ok {
            return v
        }
        a := x%2 + solve(x/2)
        b := x%3 + solve(x/3)
        res := 1 + a
        if b < a {
            res = 1 + b
        }
        memo[x] = res
        return res
    }
    return solve(n)
}
