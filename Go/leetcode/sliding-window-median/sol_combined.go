package main

import "sort"

func medianSlidingWindow(nums []int, k int) []float64 {
    res := []float64{}
    n := len(nums)
    for i := 0; i+k <= n; i++ {
        w := make([]int, k)
        copy(w, nums[i:i+k])
        sort.Ints(w)
        var median float64
        if k%2 == 1 {
            median = float64(w[k/2])
        } else {
            median = (float64(w[k/2-1]) + float64(w[k/2])) / 2.0
        }
        res = append(res, median)
    }
    return res
}
