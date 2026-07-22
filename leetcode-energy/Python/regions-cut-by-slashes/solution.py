from typing import List

class Solution:
    def regionsBySlashes(self, grid: List[str]) -> int:
        n = len(grid)
        parent = list(range(4 * n * n))
        rank = [0] * (4 * n * n)
        regions = 4 * n * n

        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(a: int, b: int) -> None:
            nonlocal regions
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if rank[ra] < rank[rb]:
                parent[ra] = rb
            elif rank[ra] > rank[rb]:
                parent[rb] = ra
            else:
                parent[rb] = ra
                rank[ra] += 1
            regions -= 1

        for i in range(n):
            for j in range(n):
                base = 4 * (i * n + j)
                ch = grid[i][j]

                if ch == ' ':
                    union(base + 0, base + 1)
                    union(base + 1, base + 2)
                    union(base + 2, base + 3)
                elif ch == '/':
                    union(base + 0, base + 3)
                    union(base + 1, base + 2)
                else:
                    union(base + 0, base + 1)
                    union(base + 2, base + 3)

                if i + 1 < n:
                    bottom = base + 2
                    below_top = 4 * ((i + 1) * n + j) + 0
                    union(bottom, below_top)

                if j + 1 < n:
                    right = base + 1
                    next_left = 4 * (i * n + j + 1) + 3
                    union(right, next_left)

        return regions
