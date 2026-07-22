from typing import List
from collections import deque

class Solution:
    def cutOffTree(self, forest: List[List[int]]) -> int:
        m, n = len(forest), len(forest[0])
        
        if forest[0][0] == 0:
            return -1
        
        trees = []
        for r in range(m):
            for c in range(n):
                if forest[r][c] > 1:
                    trees.append((forest[r][c], r, c))
        
        trees.sort()
        
        def bfs(sr: int, sc: int, tr: int, tc: int) -> int:
            if sr == tr and sc == tc:
                return 0
            
            q = deque([(sr, sc, 0)])
            seen = [[False] * n for _ in range(m)]
            seen[sr][sc] = True
            
            while q:
                r, c, dist = q.popleft()
                
                for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    nr, nc = r + dr, c + dc
                    
                    if 0 <= nr < m and 0 <= nc < n and not seen[nr][nc] and forest[nr][nc] != 0:
                        if nr == tr and nc == tc:
                            return dist + 1
                        
                        seen[nr][nc] = True
                        q.append((nr, nc, dist + 1))
            
            return -1
        
        total_steps = 0
        cr, cc = 0, 0
        
        for _, tr, tc in trees:
            steps = bfs(cr, cc, tr, tc)
            if steps == -1:
                return -1
            
            total_steps += steps
            cr, cc = tr, tc
        
        return total_steps
