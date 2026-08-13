package main

func splitArray(nums []int, k int) int {
    lo, hi := 0, 0
    for _, x := range nums {
        if x > lo {
            lo = x
        }
        hi += x
    }
    for lo < hi {
        mid := lo + (hi-lo)/2
        cnt, cur := 1, 0
        for _, x := range nums {
            if cur+x > mid {
                cnt++
                cur = x
            } else {
                cur += x
            }
        }
        if cnt <= k {
            hi = mid
        } else {
            lo = mid + 1
        }
    }
    return lo
}
