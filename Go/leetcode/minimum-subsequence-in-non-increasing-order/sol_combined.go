package main

import "sort"

func minSubsequence(nums []int) []int {
    sort.Sort(sort.Reverse(sort.IntSlice(nums)))
    total := 0
    for _, x := range nums {
        total += x
    }
    running := 0
    res := []int{}
    for _, x := range nums {
        running += x
        res = append(res, x)
        if running*2 > total {
            break
        }
    }
    return res
}
