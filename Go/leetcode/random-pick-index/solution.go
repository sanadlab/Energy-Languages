import "math/rand"

type Solution struct {
	nums []int
}

func Constructor(nums []int) Solution {
	return Solution{nums: nums}
}

func (this *Solution) Pick(target int) int {
	count := 0
	res := -1
	for i, x := range this.nums {
		if x == target {
			count++
			if rand.Intn(count) == 0 {
				res = i
			}
		}
	}
	return res
}
