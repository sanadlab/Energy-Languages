# @param {Integer[][]} points
# @return {Integer}
def max_points(points)
    n = points.length
    return n if n <= 2
    best = 1
    (0...n).each do |i|
        slopes = Hash.new(0)
        ((i + 1)...n).each do |j|
            dx = points[j][0] - points[i][0]
            dy = points[j][1] - points[i][1]
            next if dx == 0 && dy == 0
            g = dx.abs.gcd(dy.abs)
            dx /= g
            dy /= g
            if dx < 0 || (dx == 0 && dy < 0)
                dx = -dx
                dy = -dy
            end
            key = [dx, dy]
            slopes[key] += 1
            best = slopes[key] + 1 if slopes[key] + 1 > best
        end
    end
    best
end
