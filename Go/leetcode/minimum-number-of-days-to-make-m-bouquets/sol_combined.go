package main

func minDays(bloomDay []int, m int, k int) int {
    if m*k > len(bloomDay) {
        return -1
    }
    lo, hi := bloomDay[0], bloomDay[0]
    for _, b := range bloomDay {
        if b < lo {
            lo = b
        }
        if b > hi {
            hi = b
        }
    }
    canMake := func(day int) bool {
        bouquets, flowers := 0, 0
        for _, b := range bloomDay {
            if b <= day {
                flowers++
                if flowers == k {
                    bouquets++
                    flowers = 0
                }
            } else {
                flowers = 0
            }
        }
        return bouquets >= m
    }
    for lo < hi {
        mid := lo + (hi-lo)/2
        if canMake(mid) {
            hi = mid
        } else {
            lo = mid + 1
        }
    }
    return lo
}
