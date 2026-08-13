func countMaxOrSubsets(nums []int) int {
	maxOr := 0
	for _, v := range nums {
		maxOr |= v
	}
	n := len(nums)
	count := 0
	for mask := 1; mask < (1 << n); mask++ {
		cur := 0
		for i := 0; i < n; i++ {
			if mask&(1<<i) != 0 {
				cur |= nums[i]
			}
		}
		if cur == maxOr {
			count++
		}
	}
	return count
}
