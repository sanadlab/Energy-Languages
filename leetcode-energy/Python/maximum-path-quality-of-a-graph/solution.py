from collections import defaultdict

class Solution:
    def maximalPathQuality(self, values, edges, maxTime: int) -> int:
        n = len(values)
        graph = defaultdict(list)
        for u, v, t in edges:
            graph[u].append((v, t))
            graph[v].append((u, t))
        
        max_quality = 0
        visited = [0] * n
        visited[0] = 1
        path_quality = values[0]
        
        def dfs(node, time_spent, quality):
            nonlocal max_quality
            if node == 0:
                max_quality = max(max_quality, quality)
            for nxt, t in graph[node]:
                new_time = time_spent + t
                if new_time <= maxTime:
                    added_quality = 0
                    if visited[nxt] == 0:
                        added_quality = values[nxt]
                    visited[nxt] += 1
                    dfs(nxt, new_time, quality + added_quality)
                    visited[nxt] -= 1
        
        dfs(0, 0, path_quality)
        return max_quality
