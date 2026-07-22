from typing import List

class Solution:
    def cherryPickup(self, grid: List[List[int]]) -> int:
        rows, cols = len(grid), len(grid[0])
        neg = -10**9
        
        prev = [[neg] * cols for _ in range(cols)]
        prev[0][cols - 1] = grid[0][0] + grid[0][cols - 1]
        
        for r in range(1, rows):
            curr = [[neg] * cols for _ in range(cols)]
            
            for c1 in range(cols):
                for c2 in range(cols):
                    best = neg
                    
                    for dc1 in (-1, 0, 1):
                        pc1 = c1 - dc1
                        if pc1 < 0 or pc1 >= cols:
                            continue
                        
                        for dc2 in (-1, 0, 1):
                            pc2 = c2 - dc2
                            if 0 <= pc2 < cols:
                                best = max(best, prev[pc1][pc2])
                    
                    if best == neg:
                        continue
                    
                    cherries = grid[r][c1]
                    if c1 != c2:
                        cherries += grid[r][c2]
                    
                    curr[c1][c2] = best + cherries
            
            prev = curr
        
        return max(max(row) for row in prev)
