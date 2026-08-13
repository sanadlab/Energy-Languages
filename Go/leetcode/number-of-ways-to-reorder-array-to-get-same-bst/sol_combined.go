package main

func numOfWays(nums []int) int {
	const MOD = 1000000007
	n := len(nums)
	C := make([][]int64, n+1)
	for i := 0; i <= n; i++ {
		C[i] = make([]int64, n+1)
		C[i][0] = 1
		for j := 1; j <= i; j++ {
			C[i][j] = (C[i-1][j-1] + C[i-1][j]) % MOD
		}
	}
	var ways func(arr []int) int64
	ways = func(arr []int) int64 {
		m := len(arr)
		if m <= 2 {
			return 1
		}
		root := arr[0]
		var left, right []int
		for i := 1; i < m; i++ {
			if arr[i] < root {
				left = append(left, arr[i])
			} else {
				right = append(right, arr[i])
			}
		}
		return C[m-1][len(left)] * ways(left) % MOD * ways(right) % MOD
	}
	return int((ways(nums) - 1 + MOD) % MOD)
}
