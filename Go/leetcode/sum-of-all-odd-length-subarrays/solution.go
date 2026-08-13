func sumOddLengthSubarrays(arr []int) int {
    n := len(arr)
    total := 0
    for i := 0; i < n; i++ {
        count := ((i+1)*(n-i) + 1) / 2
        total += count * arr[i]
    }
    return total
}
