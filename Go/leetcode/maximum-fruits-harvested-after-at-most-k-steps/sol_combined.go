package main

func maxTotalFruits(fruits [][]int, startPos int, k int) int {
	cost := func(posL, posR int) int {
		if posR <= startPos {
			return startPos - posL
		}
		if posL >= startPos {
			return posR - startPos
		}
		left := startPos - posL
		right := posR - startPos
		m := left
		if right < m {
			m = right
		}
		return (posR - posL) + m
	}
	n := len(fruits)
	best, sum, i := 0, 0, 0
	for j := 0; j < n; j++ {
		sum += fruits[j][1]
		for i <= j && cost(fruits[i][0], fruits[j][0]) > k {
			sum -= fruits[i][1]
			i++
		}
		if i <= j && sum > best {
			best = sum
		}
	}
	return best
}
