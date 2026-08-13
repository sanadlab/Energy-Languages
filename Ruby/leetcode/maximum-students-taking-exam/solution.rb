# @param {Character[][]} seats
# @return {Integer}
def max_students(seats)
  m = seats.length
  return 0 if m == 0
  n = seats[0].length
  avail = Array.new(m, 0)
  (0...m).each do |i|
    (0...n).each do |j|
      avail[i] |= (1 << j) if j < seats[i].length && seats[i][j] == '.'
    end
  end
  full = 1 << n
  best = Array.new(full, -1)
  best[0] = 0
  (0...m).each do |i|
    ndp = Array.new(full, -1)
    (0...full).each do |mask|
      next if (mask & avail[i]) != mask
      next if (mask & (mask << 1)) != 0
      pc = mask.to_s(2).count('1')
      (0...full).each do |pmask|
        next if best[pmask] < 0
        next if (mask & (pmask << 1)) != 0
        next if (mask & (pmask >> 1)) != 0
        val = best[pmask] + pc
        ndp[mask] = val if val > ndp[mask]
      end
    end
    best = ndp
  end
  best.max
end
