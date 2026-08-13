package main

import "sort"

func suggestedProducts(products []string, searchWord string) [][]string {
    sort.Strings(products)
    result := make([][]string, 0, len(searchWord))
    for i := 0; i < len(searchWord); i++ {
        prefix := searchWord[:i+1]
        suggestions := []string{}
        for _, p := range products {
            if len(p) >= len(prefix) && p[:len(prefix)] == prefix {
                suggestions = append(suggestions, p)
                if len(suggestions) == 3 {
                    break
                }
            }
        }
        result = append(result, suggestions)
    }
    return result
}
