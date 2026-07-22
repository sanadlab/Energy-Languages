from typing import List

class Solution:
    def eventualSafeNodes(self, graph: List[List[int]]) -> List[int]:
        n = len(graph)
        # States: 0 = unvisited, 1 = visiting, 2 = safe
        state = [0] * n
        
        def dfs(node: int) -> bool:
            if state[node] != 0:
                return state[node] == 2
            state[node] = 1  # mark as visiting
            for nei in graph[node]:
                if not dfs(nei):
                    return False
            state[node] = 2  # mark as safe
            return True
        
        return [i for i in range(n) if dfs(i)]
