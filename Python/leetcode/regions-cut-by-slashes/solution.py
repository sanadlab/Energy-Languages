from typing import List


class Solution:
    def regionsBySlashes(self, grid: List[str]) -> int:
        n = len(grid)
        parent = list(range(4 * n * n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(a, b):
            ra, rb = find(a), find(b)
            if ra != rb:
                parent[ra] = rb

        for r in range(n):
            row = grid[r]
            for c in range(n):
                base = 4 * (r * n + c)
                top, right, bottom, left = base, base + 1, base + 2, base + 3
                ch = row[c] if c < len(row) else ' '
                if ch == '/':
                    union(top, left)
                    union(right, bottom)
                elif ch == '\\':
                    union(top, right)
                    union(left, bottom)
                else:
                    union(top, right)
                    union(right, bottom)
                    union(bottom, left)
                if c + 1 < n:
                    union(right, 4 * (r * n + c + 1) + 3)
                if r + 1 < n:
                    union(bottom, 4 * ((r + 1) * n + c))
        return sum(1 for i in range(4 * n * n) if find(i) == i)
