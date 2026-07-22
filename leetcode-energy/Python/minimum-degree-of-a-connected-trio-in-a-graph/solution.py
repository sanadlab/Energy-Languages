from typing import List

class Solution:
    def minTrioDegree(self, n: int, edges: List[List[int]]) -> int:
        adj = [[False] * n for _ in range(n)]
        deg = [0] * n
        
        for u, v in edges:
            u -= 1
            v -= 1
            adj[u][v] = adj[v][u] = True
            deg[u] += 1
            deg[v] += 1
        
        ans = float("inf")
        
        for i in range(n):
            for j in range(i + 1, n):
                if adj[i][j]:
                    for k in range(j + 1, n):
                        if adj[i][k] and adj[j][k]:
                            ans = min(ans, deg[i] + deg[j] + deg[k] - 6)
                            if ans == 0:
                                return 0
        
        return -1 if ans == float("inf") else ans
