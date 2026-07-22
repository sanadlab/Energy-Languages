from typing import List

class Solution:
    def cherryPickup(self, grid: List[List[int]]) -> int:
        n = len(grid)
        neg = float("-inf")
        
        dp = [[neg] * n for _ in range(n)]
        dp[0][0] = grid[0][0]
        
        for k in range(1, 2 * n - 1):
            ndp = [[neg] * n for _ in range(n)]
            
            r_min = max(0, k - (n - 1))
            r_max = min(n - 1, k)
            
            for r1 in range(r_min, r_max + 1):
                c1 = k - r1
                if grid[r1][c1] == -1:
                    continue
                
                for r2 in range(r_min, r_max + 1):
                    c2 = k - r2
                    if grid[r2][c2] == -1:
                        continue
                    
                    best = dp[r1][r2]
                    
                    if r1 > 0:
                        best = max(best, dp[r1 - 1][r2])
                    if r2 > 0:
                        best = max(best, dp[r1][r2 - 1])
                    if r1 > 0 and r2 > 0:
                        best = max(best, dp[r1 - 1][r2 - 1])
                    
                    if best == neg:
                        continue
                    
                    cherries = grid[r1][c1]
                    if r1 != r2:
                        cherries += grid[r2][c2]
                    
                    ndp[r1][r2] = best + cherries
            
            dp = ndp
        
        return max(0, dp[n - 1][n - 1])
