from typing import List

class Solution:
    def minDays(self, grid: List[List[int]]) -> int:
        rows, cols = len(grid), len(grid[0])
        def count_islands():
            visited = [[False] * cols for _ in range(rows)]
            count = 0
            for i in range(rows):
                for j in range(cols):
                    if grid[i][j] == 1 and not visited[i][j]:
                        count += 1
                        stack = [(i, j)]
                        visited[i][j] = True
                        while stack:
                            x, y = stack.pop()
                            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                                nx, ny = x + dx, y + dy
                                if 0 <= nx < rows and 0 <= ny < cols and grid[nx][ny] == 1 and not visited[nx][ny]:
                                    visited[nx][ny] = True
                                    stack.append((nx, ny))
            return count
        if count_islands() != 1:
            return 0
        for i in range(rows):
            for j in range(cols):
                if grid[i][j] == 1:
                    grid[i][j] = 0
                    if count_islands() != 1:
                        grid[i][j] = 1
                        return 1
                    grid[i][j] = 1
        return 2
