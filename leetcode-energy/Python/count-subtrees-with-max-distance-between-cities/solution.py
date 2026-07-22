from typing import List

class Solution:
    def countSubgraphsForEachDiameter(self, n: int, edges: List[List[int]]) -> List[int]:
        edge_list = [(u - 1, v - 1) for u, v in edges]
        
        INF = 10**9
        dist = [[INF] * n for _ in range(n)]
        for i in range(n):
            dist[i][i] = 0
        
        for u, v in edge_list:
            dist[u][v] = dist[v][u] = 1
        
        for k in range(n):
            for i in range(n):
                for j in range(n):
                    if dist[i][j] > dist[i][k] + dist[k][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
        
        ans = [0] * (n - 1)
        
        for mask in range(1, 1 << n):
            node_count = mask.bit_count()
            if node_count < 2:
                continue
            
            edge_count = 0
            for u, v in edge_list:
                if (mask >> u) & 1 and (mask >> v) & 1:
                    edge_count += 1
            
            if edge_count != node_count - 1:
                continue
            
            diameter = 0
            for i in range(n):
                if not ((mask >> i) & 1):
                    continue
                for j in range(i + 1, n):
                    if (mask >> j) & 1:
                        diameter = max(diameter, dist[i][j])
            
            ans[diameter - 1] += 1
        
        return ans
