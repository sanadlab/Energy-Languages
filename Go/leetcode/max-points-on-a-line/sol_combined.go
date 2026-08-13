package main

func maxPoints(points [][]int) int {
	n := len(points)
	if n <= 2 {
		return n
	}
	best := 1
	for i := 0; i < n; i++ {
		slopes := make(map[[2]int]int)
		for j := i + 1; j < n; j++ {
			dx := points[j][0] - points[i][0]
			dy := points[j][1] - points[i][1]
			g := gcdMaxPoints(absMaxPoints(dx), absMaxPoints(dy))
			dx /= g
			dy /= g
			if dx < 0 || (dx == 0 && dy < 0) {
				dx, dy = -dx, -dy
			}
			key := [2]int{dx, dy}
			slopes[key]++
			if slopes[key]+1 > best {
				best = slopes[key] + 1
			}
		}
	}
	return best
}

func gcdMaxPoints(a, b int) int {
	for b != 0 {
		a, b = b, a%b
	}
	return a
}

func absMaxPoints(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
