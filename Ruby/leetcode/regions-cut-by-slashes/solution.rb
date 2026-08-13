# @param {String[]} grid
# @return {Integer}
def regions_by_slashes(grid)
    n = grid.length
    parent = (0...(4 * n * n)).to_a
    find = lambda do |x|
        while parent[x] != x
            parent[x] = parent[parent[x]]
            x = parent[x]
        end
        x
    end
    union = lambda do |a, b|
        ra = find.call(a); rb = find.call(b)
        parent[ra] = rb if ra != rb
    end
    (0...n).each do |r|
        (0...n).each do |c|
            base = 4 * (r * n + c)
            top, right, bottom, left = base, base + 1, base + 2, base + 3
            ch = c < grid[r].length ? grid[r][c] : ' '
            if ch == '/'
                union.call(top, left); union.call(right, bottom)
            elsif ch == '\\'
                union.call(top, right); union.call(left, bottom)
            else
                union.call(top, right); union.call(right, bottom); union.call(bottom, left)
            end
            union.call(right, 4 * (r * n + c + 1) + 3) if c + 1 < n
            union.call(bottom, 4 * ((r + 1) * n + c)) if r + 1 < n
        end
    end
    cnt = 0
    (0...(4 * n * n)).each { |i| cnt += 1 if find.call(i) == i }
    cnt
end
