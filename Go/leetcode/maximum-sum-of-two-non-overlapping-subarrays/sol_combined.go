package main

func mstBest(pre []int, n, L, M int) int {
    res, maxL := 0, 0
    for i := L + M; i <= n; i++ {
        if v := pre[i-M] - pre[i-M-L]; v > maxL {
            maxL = v
        }
        if v := maxL + pre[i] - pre[i-M]; v > res {
            res = v
        }
    }
    return res
}

func maxSumTwoNoOverlap(nums []int, firstLen int, secondLen int) int {
    n := len(nums)
    pre := make([]int, n+1)
    for i := 0; i < n; i++ {
        pre[i+1] = pre[i] + nums[i]
    }
    a := mstBest(pre, n, firstLen, secondLen)
    b := mstBest(pre, n, secondLen, firstLen)
    if a > b {
        return a
    }
    return b
}
