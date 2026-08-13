func minStartValue(nums []int) int {
    prefix, minPrefix := 0, 0
    for _, x := range nums {
        prefix += x
        if prefix < minPrefix {
            minPrefix = prefix
        }
    }
    if 1-minPrefix > 1 {
        return 1 - minPrefix
    }
    return 1
}
