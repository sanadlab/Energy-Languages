package main


import (
	"sort"
)

func findKDistantIndices(nums []int, key int, k int) []int {
	var result []int
	keyIndices := []int{}

	// Find all indices where nums[j] == key
	for j, num := range nums {
		if num == key {
			keyIndices = append(keyIndices, j)
		}
	}

	// Check each index i in nums to see if it is k-distant from any key index
	for i := 0; i < len(nums); i++ {
		for _, keyIndex := range keyIndices {
			if abs(i-keyIndex) <= k {
				result = append(result, i)
				break
			}
		}
	}

	// Sort the result in increasing order
	sort.Ints(result)

	return result
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
