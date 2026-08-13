package solution

func diStringMatch(s string) []int {
    n := len(s)
    low, high := 0, n
    perm := make([]int, n+1)

    for i, ch := range s {
        if ch == 'I' {
            perm[i] = low
            low++
        } else { // ch == 'D'
            perm[i] = high
            high--
        }
    }

    // Assign the last remaining value to the last position
    perm[n] = low

    return perm
}