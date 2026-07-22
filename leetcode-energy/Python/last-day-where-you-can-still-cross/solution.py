from typing import List

class Solution:
    def latestDayToCross(self, row: int, col: int, cells: List[List[int]]) -> int:
        n = row * col
        top = n
        bottom = n + 1

        parent = list(range(n + 2))
        size = [1] * (n + 2)

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

        land = [False] * n
        directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

        for day in range(n - 1, -1, -1):
            r, c = cells[day]
            r -= 1
            c -= 1
            idx = r * col + c
            land[idx] = True

            if r == 0:
                union(idx, top)
            if r == row - 1:
                union(idx, bottom)

            for dr, dc in directions:
                nr, nc = r + dr, c + dc
                if 0 <= nr < row and 0 <= nc < col:
                    nei = nr * col + nc
                    if land[nei]:
                        union(idx, nei)

            if find(top) == find(bottom):
                return day

        return 0
