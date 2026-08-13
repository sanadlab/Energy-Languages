func checkStraightLine(coordinates [][]int) bool {
	x0, y0 := coordinates[0][0], coordinates[0][1]
	dx, dy := coordinates[1][0]-x0, coordinates[1][1]-y0
	for i := 2; i < len(coordinates); i++ {
		cx, cy := coordinates[i][0]-x0, coordinates[i][1]-y0
		if dx*cy != dy*cx {
			return false
		}
	}
	return true
}
