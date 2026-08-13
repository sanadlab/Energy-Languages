func nextGreaterElements(nums []int) []int {
    n := len(nums)
    res := make([]int, n)
    for i := range res {
        res[i] = -1
    }
    st := []int{}
    for i := 0; i < 2*n; i++ {
        cur := nums[i%n]
        for len(st) > 0 && nums[st[len(st)-1]] < cur {
            res[st[len(st)-1]] = cur
            st = st[:len(st)-1]
        }
        if i < n {
            st = append(st, i)
        }
    }
    return res
}
