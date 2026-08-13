# @param {Integer[][]} grid
# @param {Integer[][]} hits
# @return {Integer[]}
def hit_bricks(grid, hits)
  m = grid.length
  n = (m > 0 && grid[0].is_a?(Array)) ? grid[0].length : 0
  total = m * n
  top = total
  parent = (0..total).to_a
  sz = Array.new(total + 1, 1)

  find = lambda do |x|
    while parent[x] != x
      parent[x] = parent[parent[x]]
      x = parent[x]
    end
    x
  end

  union = lambda do |a, b|
    ra = find.call(a)
    rb = find.call(b)
    next if ra == rb

    ra, rb = rb, ra if sz[ra] < sz[rb]
    parent[rb] = ra
    sz[ra] += sz[rb]
  end

  in_bounds = lambda { |r, c| r >= 0 && r < m && c >= 0 && c < n }

  g = Array.new(m) { Array.new(n, 0) }
  (0...m).each do |r|
    row = grid[r].is_a?(Array) ? grid[r] : []
    (0...[n, row.length].min).each do |c|
      g[r][c] = 1 if row[c] == 1
    end
  end

  hits.each do |h|
    next unless h.is_a?(Array) && h.length >= 2

    r, c = h[0], h[1]
    g[r][c] = 0 if in_bounds.call(r, c)
  end

  (0...m).each do |r|
    (0...n).each do |c|
      next unless g[r][c] == 1

      cur = r * n + c
      union.call(cur, top) if r == 0
      union.call(cur, (r - 1) * n + c) if r > 0 && g[r - 1][c] == 1
      union.call(cur, r * n + c - 1) if c > 0 && g[r][c - 1] == 1
    end
  end

  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  res = Array.new(hits.length, 0)
  (hits.length - 1).downto(0) do |i|
    h = hits[i]
    next unless h.is_a?(Array) && h.length >= 2

    r, c = h[0], h[1]
    next unless in_bounds.call(r, c)
    next unless grid[r].is_a?(Array) && grid[r][c] == 1

    before = sz[find.call(top)]
    g[r][c] = 1
    cur = r * n + c
    union.call(cur, top) if r == 0
    dirs.each do |d|
      nr = r + d[0]
      nc = c + d[1]
      union.call(cur, nr * n + nc) if in_bounds.call(nr, nc) && g[nr][nc] == 1
    end
    after = sz[find.call(top)]
    f = after - before - 1
    res[i] = f > 0 ? f : 0
  end
  res
end
