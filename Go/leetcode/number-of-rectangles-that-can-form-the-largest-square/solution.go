func countGoodRectangles(rectangles [][]int) int {
	maxLen, count := 0, 0
	for _, r := range rectangles {
		side := r[0]
		if r[1] < side {
			side = r[1]
		}
		if side > maxLen {
			maxLen = side
			count = 1
		} else if side == maxLen {
			count++
		}
	}
	return count
}
