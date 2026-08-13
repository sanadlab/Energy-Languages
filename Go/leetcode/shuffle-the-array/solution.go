func shuffle(nums []int, n int) []int {
    m := len(nums) / 2
    res := make([]int, 0, 2*m)
    for i := 0; i < m; i++ {
        res = append(res, nums[i], nums[i+m])
    }
    return res
}
