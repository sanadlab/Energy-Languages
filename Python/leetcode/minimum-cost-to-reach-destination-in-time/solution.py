from typing import List

class Solution:
    def minCost(self, maxTime: int, edges: List[List[int]], passingFees: List[int]) -> int:
        n = len(passingFees)
        INF = 1 << 29
        adj = [[] for _ in range(n)]
        for e in edges:
            if len(e) < 3:
                continue
            x, y, w = e[0], e[1], e[2]
            if x < 0 or x >= n or y < 0 or y >= n or w < 0:
                continue
            adj[x].append((y, w))
            adj[y].append((x, w))
        dp = [[INF] * n for _ in range(maxTime + 1)]
        dp[0][0] = passingFees[0]
        ans = INF
        for t in range(maxTime + 1):
            row = dp[t]
            for u in range(n):
                cur = row[u]
                if cur >= INF:
                    continue
                if u == n - 1 and cur < ans:
                    ans = cur
                for v, w in adj[u]:
                    nt = t + w
                    if nt <= maxTime and cur + passingFees[v] < dp[nt][v]:
                        dp[nt][v] = cur + passingFees[v]
        return -1 if ans >= INF else ans
