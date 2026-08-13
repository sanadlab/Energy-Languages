package main

import "sort"

func maximumBeauty(flowers []int, newFlowers int64, target int, full int, partial int) int64 {
    n := len(flowers)
    if n == 0 {
        return 0
    }
    fl := make([]int, n)
    for i := 0; i < n; i++ {
        if flowers[i] < target {
            fl[i] = flowers[i]
        } else {
            fl[i] = target
        }
    }
    sort.Ints(fl)
    pre := make([]int64, n+1)
    for i := 0; i < n; i++ {
        pre[i+1] = pre[i] + int64(fl[i])
    }
    if fl[0] == target {
        return int64(full) * int64(n)
    }
    var ans int64 = 0
    for i := n; i >= 0; i-- {
        costComplete := int64(target)*int64(n-i) - (pre[n] - pre[i])
        if costComplete > newFlowers {
            continue
        }
        rem := newFlowers - costComplete
        if i == 0 {
            if v := int64(full) * int64(n-i); v > ans {
                ans = v
            }
            continue
        }
        lo, hi, bestMin := 0, target-1, 0
        for lo <= hi {
            v := lo + (hi-lo)/2
            k := sort.SearchInts(fl[:i], v)
            cost := int64(v)*int64(k) - pre[k]
            if cost <= rem {
                bestMin = v
                lo = v + 1
            } else {
                hi = v - 1
            }
        }
        if val := int64(full)*int64(n-i) + int64(bestMin)*int64(partial); val > ans {
            ans = val
        }
    }
    return ans
}
