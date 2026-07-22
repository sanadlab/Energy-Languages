from typing import List
from collections import deque

class Solution:
    def minMalwareSpread(self, graph: List[List[int]], initial: List[int]) -> int:
        n = len(graph)
        initial_set = set(initial)
        initial.sort()
        
        def infected_count_after_removal(remove_node: int) -> int:
            # BFS to find infected nodes after removing remove_node from initial and graph
            infected = set()
            visited = [False] * n
            
            # Build new initial set without remove_node
            new_initial = [node for node in initial if node != remove_node]
            
            # Mark remove_node as removed: no edges from/to it
            # We simulate this by ignoring it in BFS and ignoring edges to/from it
            
            queue = deque(new_initial)
            for node in new_initial:
                visited[node] = True
                infected.add(node)
            
            while queue:
                u = queue.popleft()
                for v in range(n):
                    if v == remove_node:
                        continue
                    if graph[u][v] == 1 and not visited[v]:
                        visited[v] = True
                        infected.add(v)
                        queue.append(v)
            return len(infected)
        
        best_node = None
        best_infected = float('inf')
        for node in initial:
            count = infected_count_after_removal(node)
            if count < best_infected or (count == best_infected and node < best_node):
                best_infected = count
                best_node = node
        
        return best_node
