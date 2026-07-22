from typing import List
from collections import deque

class Solution:
    def minDays(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        
        def count_islands():
            visited = [[False]*n for _ in range(m)]
            def bfs(sr, sc):
                q = deque([(sr, sc)])
                visited[sr][sc] = True
                while q:
                    r, c = q.popleft()
                    for nr, nc in [(r-1,c),(r+1,c),(r,c-1),(r,c+1)]:
                        if 0 <= nr < m and 0 <= nc < n and not visited[nr][nc] and grid[nr][nc] == 1:
                            visited[nr][nc] = True
                            q.append((nr,nc))
            
            islands = 0
            for i in range(m):
                for j in range(n):
                    if grid[i][j] == 1 and not visited[i][j]:
                        islands += 1
                        if islands > 1:
                            return islands
                        bfs(i,j)
            return islands
        
        # If already disconnected (0 or >1 islands), return 0
        if count_islands() != 1:
            return 0
        
        # Check if removing one land cell disconnects the island
        for i in range(m):
            for j in range(n):
                if grid[i][j] == 1:
                    grid[i][j] = 0
                    if count_islands() != 1:
                        grid[i][j] = 1
                        return 1
                    grid[i][j] = 1
        
        # Otherwise, it takes at least 2 days
        return 2
