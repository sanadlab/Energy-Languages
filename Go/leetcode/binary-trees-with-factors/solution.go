import "sort"

func numFactoredBinaryTrees(arr []int) int {
	sort.Ints(arr)
	const MOD int64 = 1000000007
	dp := make(map[int]int64)
	var ans int64 = 0
	for i := 0; i < len(arr); i++ {
		var cnt int64 = 1
		for j := 0; j < i; j++ {
			if arr[i]%arr[j] == 0 {
				b := arr[i] / arr[j]
				if bv, ok := dp[b]; ok {
					cnt = (cnt + dp[arr[j]]*bv) % MOD
				}
			}
		}
		dp[arr[i]] = cnt
		ans = (ans + cnt) % MOD
	}
	return int(ans)
}
