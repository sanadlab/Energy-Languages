import (
    "math/bits"
    "sort"
)

func sortByBits(arr []int) []int {
    sort.Slice(arr, func(i, j int) bool {
        bi, bj := bits.OnesCount(uint(arr[i])), bits.OnesCount(uint(arr[j]))
        if bi != bj {
            return bi < bj
        }
        return arr[i] < arr[j]
    })
    return arr
}
