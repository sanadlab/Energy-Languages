# @param {Integer[][]} rectangles
# @return {Integer}
def count_good_rectangles(rectangles)
  max_len = 0
  count = 0
  rectangles.each do |r|
    side = r.is_a?(Array) ? [r[0], r[1]].min : r
    if side > max_len
      max_len = side
      count = 1
    elsif side == max_len
      count += 1
    end
  end
  count
end
