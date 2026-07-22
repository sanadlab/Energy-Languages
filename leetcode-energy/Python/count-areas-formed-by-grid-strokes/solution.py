class Solution:
    def regionsBySlashes(self, grid: list[str]) -> int:
        n = len(grid)
        # Each cell is divided into 4 parts:
        # 0: top-left triangle
        # 1: top-right triangle
        # 2: bottom-right triangle
        # 3: bottom-left triangle
        # We will use Union-Find to connect these parts within and across cells.

        parent = list(range(4 * n * n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        def union(x, y):
            px, py = find(x), find(y)
            if px != py:
                parent[px] = py

        def index(r, c, part):
            return (r * n + c) * 4 + part

        for r in range(n):
            for c in range(n):
                ch = grid[r][c]
                # Connect internal parts of the cell
                if ch == ' ':
                    # all 4 parts connected
                    union(index(r, c, 0), index(r, c, 1))
                    union(index(r, c, 1), index(r, c, 2))
                    union(index(r, c, 2), index(r, c, 3))
                elif ch == '/':
                    # connect 0-3 and 1-2
                    union(index(r, c, 0), index(r, c, 3))
                    union(index(r, c, 1), index(r, c, 2))
                else:  # ch == '\\'
                    # connect 0-1 and 2-3
                    union(index(r, c, 0), index(r, c, 1))
                    union(index(r, c, 2), index(r, c, 3))

                # Connect with right cell
                if c + 1 < n:
                    union(index(r, c, 1), index(r, c + 1, 3))
                # Connect with bottom cell
                if r + 1 < n:
                    union(index(r, c, 2), index(r + 1, c, 0))

        # Count distinct parents
        regions = 0
        for i in range(4 * n * n):
            if find(i) == i:
                regions += 1
        return regions
