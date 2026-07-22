from heapq import heappush, heappop
from collections import defaultdict

class Solution:
    def minCost(self, maxTime: int, edges: list[list[int]], passingFees: list[int]) -> int:
        n = len(passingFees)
        graph = defaultdict(list)
        for u, v, t in edges:
            graph[u].append((v, t))
            graph[v].append((u, t))
        
        # dist[node][time] = minimum cost to reach node with exactly time spent
        # To optimize memory, we keep track of the minimum cost to reach node with time <= maxTime
        # We'll use a 2D array or dictionary, but since maxTime and n can be up to 1000, 
        # we use a 2D list with initial large values.
        dist = [[float('inf')] * (maxTime + 1) for _ in range(n)]
        dist[0][0] = passingFees[0]
        
        # Min-heap: (cost, time, node)
        heap = [(passingFees[0], 0, 0)]
        
        while heap:
            cost, time_spent, node = heappop(heap)
            if node == n - 1:
                return cost
            if cost > dist[node][time_spent]:
                continue
            for nxt, t in graph[node]:
                new_time = time_spent + t
                if new_time <= maxTime:
                    new_cost = cost + passingFees[nxt]
                    if new_cost < dist[nxt][new_time]:
                        dist[nxt][new_time] = new_cost
                        heappush(heap, (new_cost, new_time, nxt))
        
        return -1
