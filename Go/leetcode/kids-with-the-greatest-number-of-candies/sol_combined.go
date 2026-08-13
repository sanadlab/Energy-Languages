package main

func kidsWithCandies(candies []int, extraCandies int) []bool {
    maxCandies := 0
    for _, c := range candies {
        if c > maxCandies {
            maxCandies = c
        }
    }
    result := make([]bool, len(candies))
    for i, c := range candies {
        result[i] = c+extraCandies >= maxCandies
    }
    return result
}
