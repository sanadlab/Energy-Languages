func maxRunTime(n int, batteries []int) int64 {
    var sum int64 = 0
    for _, b := range batteries {
        sum += int64(b)
    }
    lo, hi := int64(0), sum/int64(n)
    for lo < hi {
        mid := (lo + hi + 1) / 2
        var avail int64 = 0
        for _, b := range batteries {
            if int64(b) < mid {
                avail += int64(b)
            } else {
                avail += mid
            }
        }
        if avail >= int64(n)*mid {
            lo = mid
        } else {
            hi = mid - 1
        }
    }
    return lo
}
