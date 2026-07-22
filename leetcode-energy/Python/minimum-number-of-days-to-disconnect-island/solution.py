from typing import List

class Solution:
    def minDays(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])

        def count_islands() -> int:
            visited = [[False] * n for _ in range(m)]
            islands = 0

            for r in range(m):
                for c in range(n):
                    if grid[r][c] == 1 and not visited[r][c]:
                        islands += 1
                        if islands > 1:
                            return islands

                        stack = [(r, c)]
                        visited[r][c] = True

                        while stack:
                            x, y = stack.pop()
                            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                                nx, ny = x + dx, y + dy
                                if (
                                    0 <= nx < m
                                    and 0 <= ny < n
                                    and grid[nx][ny] == 1
                                    and not visited[nx][ny]
                                ):
                                    visited[nx][ny] = True
                                    stack.append((nx, ny))

            return islands

        if count_islands() != 1:
            return 0

        for r in range(m):
            for c in range(n):
                if grid[r][c] == 1:
                    grid[r][c] = 0
                    if count_islands() != 1:
                        grid[r][c] = 1
                        return 1
                    grid[r][c] = 1

        return 2
