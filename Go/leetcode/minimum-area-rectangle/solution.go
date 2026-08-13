func minAreaRect(points [][]int) int {
    seen := make(map[int64]bool)
    n := len(points)
    for _, p := range points {
        seen[int64(p[0])*50000+int64(p[1])] = true
    }
    best := int64(1) << 62
    for i := 0; i < n; i++ {
        for j := i + 1; j < n; j++ {
            x1, y1 := points[i][0], points[i][1]
            x2, y2 := points[j][0], points[j][1]
            if x1 != x2 && y1 != y2 {
                if seen[int64(x1)*50000+int64(y2)] && seen[int64(x2)*50000+int64(y1)] {
                    dx := x1 - x2
                    if dx < 0 {
                        dx = -dx
                    }
                    dy := y1 - y2
                    if dy < 0 {
                        dy = -dy
                    }
                    area := int64(dx) * int64(dy)
                    if area < best {
                        best = area
                    }
                }
            }
        }
    }
    if best == int64(1)<<62 {
        return 0
    }
    return int(best)
}
