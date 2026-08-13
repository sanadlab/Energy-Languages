package solution

func isSumEqual(firstWord string, secondWord string, targetWord string) bool {
    return valueOf(firstWord) + valueOf(secondWord) == valueOf(targetWord)
}

func valueOf(s string) int {
    sum := 0
    for _, c := range s {
        sum = sum*10 + int(c-'a')
    }
    return sum
}