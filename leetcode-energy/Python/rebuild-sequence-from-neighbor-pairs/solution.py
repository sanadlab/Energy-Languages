from collections import defaultdict

class Solution:
    def restoreArray(self, adjacentPairs: list[list[int]]) -> list[int]:
        # Build adjacency list
        graph = defaultdict(list)
        for u, v in adjacentPairs:
            graph[u].append(v)
            graph[v].append(u)
        
        # Find the start node (one with only one neighbor)
        start = None
        for node, neighbors in graph.items():
            if len(neighbors) == 1:
                start = node
                break
        
        # Reconstruct the array
        n = len(adjacentPairs) + 1
        res = [0] * n
        res[0] = start
        res[1] = graph[start][0]
        
        for i in range(2, n):
            neighbors = graph[res[i-1]]
            # neighbors has either 1 or 2 elements
            # pick the neighbor that is not res[i-2]
            if neighbors[0] != res[i-2]:
                res[i] = neighbors[0]
            else:
                res[i] = neighbors[1]
        
        return res
