def largest_magic_square(grid)
    return 1 if grid.empty? || !grid[0].is_a?(Array)
    m = grid.size
    n = grid[0].size
    max_k = [m, n].min
    max_k.downto(1) do |k|
        (0..(m - k)).each do |i|
            (0..(n - k)).each do |j|
                return k if magic_square?(grid, i, j, k)
            end
        end
    end
    1
end

def magic_square?(grid, r, c, k)
    target = 0
    (0...k).each { |j| target += grid[r][c + j] }
    (0...k).each do |i|
        s = 0
        (0...k).each { |j| s += grid[r + i][c + j] }
        return false if s != target
    end
    (0...k).each do |j|
        s = 0
        (0...k).each { |i| s += grid[r + i][c + j] }
        return false if s != target
    end
    d1 = 0
    d2 = 0
    (0...k).each do |i|
        d1 += grid[r + i][c + i]
        d2 += grid[r + i][c + k - 1 - i]
    end
    d1 == target && d2 == target
end
