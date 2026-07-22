from typing import List

class Solution:
    def hitBricks(self, grid: List[List[int]], hits: List[List[int]]) -> List[int]:
        m, n = len(grid), len(grid[0])
        roof = m * n

        class DSU:
            def __init__(self, size: int):
                self.parent = list(range(size))
                self.sz = [1] * size

            def find(self, x: int) -> int:
                while self.parent[x] != x:
                    self.parent[x] = self.parent[self.parent[x]]
                    x = self.parent[x]
                return x

            def union(self, a: int, b: int) -> None:
                ra, rb = self.find(a), self.find(b)
                if ra == rb:
                    return
                if self.sz[ra] < self.sz[rb]:
                    ra, rb = rb, ra
                self.parent[rb] = ra
                self.sz[ra] += self.sz[rb]

            def size(self, x: int) -> int:
                return self.sz[self.find(x)]

        def idx(r: int, c: int) -> int:
            return r * n + c

        after_hits = [row[:] for row in grid]

        for r, c in hits:
            if after_hits[r][c] == 1:
                after_hits[r][c] = 0

        dsu = DSU(m * n + 1)

        for r in range(m):
            for c in range(n):
                if after_hits[r][c] == 1:
                    if r == 0:
                        dsu.union(idx(r, c), roof)
                    if r > 0 and after_hits[r - 1][c] == 1:
                        dsu.union(idx(r, c), idx(r - 1, c))
                    if c > 0 and after_hits[r][c - 1] == 1:
                        dsu.union(idx(r, c), idx(r, c - 1))

        result = [0] * len(hits)
        directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

        for i in range(len(hits) - 1, -1, -1):
            r, c = hits[i]

            if grid[r][c] == 0:
                continue

            before = dsu.size(roof)
            after_hits[r][c] = 1
            brick_id = idx(r, c)

            if r == 0:
                dsu.union(brick_id, roof)

            for dr, dc in directions:
                nr, nc = r + dr, c + dc
                if 0 <= nr < m and 0 <= nc < n and after_hits[nr][nc] == 1:
                    dsu.union(brick_id, idx(nr, nc))

            after = dsu.size(roof)
            result[i] = max(0, after - before - 1)

        return result
