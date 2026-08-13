# @param {Integer[][]} points
# @return {Integer}
def min_area_rect(points)
  seen = {}
  n = points.length
  points.each { |p| seen[p[0] * 50000 + p[1]] = true }
  best = Float::INFINITY
  (0...n).each do |i|
    (i + 1...n).each do |j|
      x1, y1 = points[i][0], points[i][1]
      x2, y2 = points[j][0], points[j][1]
      if x1 != x2 && y1 != y2
        if seen[x1 * 50000 + y2] && seen[x2 * 50000 + y1]
          area = (x1 - x2).abs * (y1 - y2).abs
          best = area if area < best
        end
      end
    end
  end
  best == Float::INFINITY ? 0 : best
end
