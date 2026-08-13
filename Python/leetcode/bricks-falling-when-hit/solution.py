from typing import List


class Solution:
    def hitBricks(self, grid: List[List[int]], hits: List[List[int]]) -> List[int]:
        m = len(grid)
        n = len(grid[0]) if m and isinstance(grid[0], list) else 0
        total = m * n
        top = total
        parent = list(range(total + 1))
        size = [1] * (total + 1)

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(a, b):
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if size[ra] < size[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            size[ra] += size[rb]

        def in_bounds(r, c):
            return 0 <= r < m and 0 <= c < n

        # working grid: 1 where a brick currently stands
        g = [[0] * n for _ in range(m)]
        for r in range(m):
            row = grid[r] if isinstance(grid[r], list) else []
            for c in range(min(n, len(row))):
                if row[c] == 1:
                    g[r][c] = 1

        # erase the hit bricks up-front
        for h in hits:
            if isinstance(h, (list, tuple)) and len(h) >= 2 and in_bounds(h[0], h[1]):
                g[h[0]][h[1]] = 0

        # build union-find over the bricks that remain
        for r in range(m):
            for c in range(n):
                if g[r][c] == 1:
                    cur = r * n + c
                    if r == 0:
                        union(cur, top)
                    if r > 0 and g[r - 1][c] == 1:
                        union(cur, (r - 1) * n + c)
                    if c > 0 and g[r][c - 1] == 1:
                        union(cur, r * n + c - 1)

        dirs = ((1, 0), (-1, 0), (0, 1), (0, -1))
        result = [0] * len(hits)
        for i in range(len(hits) - 1, -1, -1):
            h = hits[i]
            if not (isinstance(h, (list, tuple)) and len(h) >= 2):
                continue
            r, c = h[0], h[1]
            if not in_bounds(r, c):
                continue
            # only a brick that originally existed there can fall back into place
            if not (isinstance(grid[r], list) and c < len(grid[r]) and grid[r][c] == 1):
                continue
            before = size[find(top)]
            g[r][c] = 1
            cur = r * n + c
            if r == 0:
                union(cur, top)
            for dr, dc in dirs:
                nr, nc = r + dr, c + dc
                if in_bounds(nr, nc) and g[nr][nc] == 1:
                    union(cur, nr * n + nc)
            after = size[find(top)]
            result[i] = max(0, after - before - 1)
        return result
