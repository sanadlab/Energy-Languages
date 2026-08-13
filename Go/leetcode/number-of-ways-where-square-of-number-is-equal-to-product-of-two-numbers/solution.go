func numTriplets(nums1 []int, nums2 []int) int {
    helper := func(a []int, b []int) int64 {
        var cnt int64 = 0
        for _, x := range a {
            t := int64(x) * int64(x)
            seen := make(map[int64]int64)
            for _, y := range b {
                yy := int64(y)
                if t%yy == 0 {
                    need := t / yy
                    cnt += seen[need]
                }
                seen[yy]++
            }
        }
        return cnt
    }
    return int(helper(nums1, nums2) + helper(nums2, nums1))
}
