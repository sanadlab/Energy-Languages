# @param {Integer[][]} grid
# @param {Integer} k
# @return {Integer[][]}
def shift_grid(grid, k)
  m = grid.size
  n = grid[0].size
  total = m * n
  k %= total
  return grid if k == 0

  flat = grid.flatten
  shifted = flat[-k..-1] + flat[0...-k]

  result = Array.new(m) { Array.new(n) }
  (0...total).each do |idx|
    row = idx / n
    col = idx % n
    result[row][col] = shifted[idx]
  end

  result
end