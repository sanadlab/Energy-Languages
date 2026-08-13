package main

import "math"

func countTriples(n int) int {
	count := 0
	for a := 1; a <= n; a++ {
		for b := 1; b <= n; b++ {
			c2 := a*a + b*b
			c := int(math.Sqrt(float64(c2)) + 0.5)
			if c >= 1 && c <= n && c*c == c2 {
				count++
			}
		}
	}
	return count
}
