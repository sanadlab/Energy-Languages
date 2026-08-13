# @param {Integer[][]} coordinates
# @return {Boolean}
def check_straight_line(coordinates)
  x0, y0 = coordinates[0]
  x1, y1 = coordinates[1]

  dx = x1 - x0
  dy = y1 - y0

  (2...coordinates.length).each do |i|
    x, y = coordinates[i]
    # Check cross product (dx * (y - y0)) == (dy * (x - x0))
    return false if dy * (x - x0) != dx * (y - y0)
  end

  true
end