from collections import deque


class Solution:
    def eventualSafeNodes(self, graph):
        n = len(graph)
        rev = [[] for _ in range(n)]
        outdeg = [0] * n
        for u in range(n):
            row = graph[u] if isinstance(graph[u], (list, tuple)) else []
            for v in row:
                if 0 <= v < n:
                    rev[v].append(u)
                    outdeg[u] += 1
        q = deque(i for i in range(n) if outdeg[i] == 0)
        safe = [False] * n
        while q:
            v = q.popleft()
            safe[v] = True
            for u in rev[v]:
                outdeg[u] -= 1
                if outdeg[u] == 0:
                    q.append(u)
        return [i for i in range(n) if safe[i]]
