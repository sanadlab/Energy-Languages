from typing import List
import heapq


class Solution:
    def minimumWeight(self, n: int, edges: List[List[int]], src1: int, src2: int, dest: int) -> int:
        graph = [[] for _ in range(n)]
        rev_graph = [[] for _ in range(n)]
        
        for u, v, w in edges:
            graph[u].append((v, w))
            rev_graph[v].append((u, w))
        
        def dijkstra(start: int, adj: List[List[tuple]]) -> List[int]:
            INF = 10**30
            dist = [INF] * n
            dist[start] = 0
            heap = [(0, start)]
            
            while heap:
                cur_dist, node = heapq.heappop(heap)
                if cur_dist != dist[node]:
                    continue
                
                for nei, weight in adj[node]:
                    new_dist = cur_dist + weight
                    if new_dist < dist[nei]:
                        dist[nei] = new_dist
                        heapq.heappush(heap, (new_dist, nei))
            
            return dist
        
        dist1 = dijkstra(src1, graph)
        dist2 = dijkstra(src2, graph)
        dist_dest = dijkstra(dest, rev_graph)
        
        ans = min(dist1[i] + dist2[i] + dist_dest[i] for i in range(n))
        
        return -1 if ans >= 10**30 else ans
