package main

func maxEqualFreq(nums []int) int {
	n := len(nums)
	count := make([]int, 100001)
	freq := make([]int, n+1)
	maxF, res := 0, 0
	for i := 0; i < n; i++ {
		v := nums[i]
		if count[v] > 0 {
			freq[count[v]]--
		}
		count[v]++
		freq[count[v]]++
		if count[v] > maxF {
			maxF = count[v]
		}
		if maxF == 1 ||
			freq[maxF]*maxF == i ||
			(freq[maxF] == 1 && (maxF-1)*(freq[maxF-1]+1) == i) {
			res = i + 1
		}
	}
	return res
}
