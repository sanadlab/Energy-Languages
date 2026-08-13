package main

import "math/bits"

func maxStudents(seats [][]byte) int {
    m := len(seats)
    if m == 0 {
        return 0
    }
    n := len(seats[0])
    avail := make([]int, m)
    for i := 0; i < m; i++ {
        for j := 0; j < n && j < len(seats[i]); j++ {
            if seats[i][j] == '.' {
                avail[i] |= 1 << uint(j)
            }
        }
    }
    full := 1 << uint(n)
    best := make([]int, full)
    for k := range best {
        best[k] = -1
    }
    best[0] = 0
    for i := 0; i < m; i++ {
        ndp := make([]int, full)
        for k := range ndp {
            ndp[k] = -1
        }
        for mask := 0; mask < full; mask++ {
            if mask&avail[i] != mask {
                continue
            }
            if mask&(mask<<1) != 0 {
                continue
            }
            pc := bits.OnesCount(uint(mask))
            for pmask := 0; pmask < full; pmask++ {
                if best[pmask] < 0 {
                    continue
                }
                if mask&(pmask<<1) != 0 {
                    continue
                }
                if mask&(pmask>>1) != 0 {
                    continue
                }
                val := best[pmask] + pc
                if val > ndp[mask] {
                    ndp[mask] = val
                }
            }
        }
        best = ndp
    }
    ans := 0
    for _, v := range best {
        if v > ans {
            ans = v
        }
    }
    return ans
}
