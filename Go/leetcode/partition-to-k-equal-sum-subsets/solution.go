import "sort"

func canPartitionKSubsets(nums []int, k int) bool {
    if k <= 0 || len(nums) < k {
        return false
    }
    sum := 0
    for _, x := range nums {
        sum += x
    }
    if sum%k != 0 {
        return false
    }
    target := sum / k
    sort.Sort(sort.Reverse(sort.IntSlice(nums)))
    if nums[0] > target {
        return false
    }
    used := make([]bool, len(nums))
    var backtrack func(k, cur, start int) bool
    backtrack = func(k, cur, start int) bool {
        if k == 0 {
            return true
        }
        if cur == target {
            return backtrack(k-1, 0, 0)
        }
        for i := start; i < len(nums); i++ {
            if used[i] || cur+nums[i] > target {
                continue
            }
            used[i] = true
            if backtrack(k, cur+nums[i], i+1) {
                return true
            }
            used[i] = false
            if cur == 0 {
                break
            }
        }
        return false
    }
    return backtrack(k, 0, 0)
}
