from typing import List
from collections import defaultdict

class Solution:
    def countPairs(self, n: int, edges: List[List[int]], queries: List[int]) -> List[int]:
        deg = [0] * (n + 1)
        shared = defaultdict(int)

        for u, v in edges:
            deg[u] += 1
            deg[v] += 1
            if u > v:
                u, v = v, u
            shared[(u, v)] += 1

        sorted_deg = sorted(deg[1:])
        ans = []

        for q in queries:
            count = 0
            left, right = 0, n - 1

            while left < right:
                if sorted_deg[left] + sorted_deg[right] > q:
                    count += right - left
                    right -= 1
                else:
                    left += 1

            for (u, v), c in shared.items():
                total = deg[u] + deg[v]
                if total > q and total - c <= q:
                    count -= 1

            ans.append(count)

        return ans
