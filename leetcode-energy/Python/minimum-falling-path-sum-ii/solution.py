from typing import List

class Solution:
    def minFallingPathSum(self, grid: List[List[int]]) -> int:
        n = len(grid)
        
        min1 = min2 = 0
        min1_idx = -1
        
        for i in range(n):
            new_min1 = float("inf")
            new_min2 = float("inf")
            new_min1_idx = -1
            
            for j in range(n):
                val = grid[i][j] + (min2 if j == min1_idx else min1)
                
                if val < new_min1:
                    new_min2 = new_min1
                    new_min1 = val
                    new_min1_idx = j
                elif val < new_min2:
                    new_min2 = val
            
            min1, min2, min1_idx = new_min1, new_min2, new_min1_idx
        
        return min1
