from typing import List
from functools import lru_cache

class Solution:
    def maxCompatibilitySum(self, students: List[List[int]], mentors: List[List[int]]) -> int:
        m, n = len(students), len(students[0])
        
        # Precompute compatibility scores between each student and mentor
        comp = [[0]*m for _ in range(m)]
        for i in range(m):
            for j in range(m):
                score = 0
                for k in range(n):
                    if students[i][k] == mentors[j][k]:
                        score += 1
                comp[i][j] = score
        
        @lru_cache(None)
        def dfs(i, mask):
            if i == m:
                return 0
            max_score = 0
            for j in range(m):
                if (mask & (1 << j)) == 0:
                    max_score = max(max_score, comp[i][j] + dfs(i+1, mask | (1 << j)))
            return max_score
        
        return dfs(0, 0)
