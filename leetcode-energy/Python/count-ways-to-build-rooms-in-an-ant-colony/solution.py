from typing import List

class Solution:
    def waysToBuildRooms(self, prevRoom: List[int]) -> int:
        MOD = 10 ** 9 + 7
        n = len(prevRoom)

        children = [[] for _ in range(n)]
        for i in range(1, n):
            children[prevRoom[i]].append(i)

        order = [0]
        for u in order:
            order.extend(children[u])

        size = [1] * n
        for u in reversed(order):
            for v in children[u]:
                size[u] += size[v]

        inv = [0] * (n + 1)
        inv[1] = 1
        for i in range(2, n + 1):
            inv[i] = MOD - (MOD // i) * inv[MOD % i] % MOD

        ans = 1
        for i in range(2, n + 1):
            ans = ans * i % MOD

        for s in size:
            ans = ans * inv[s] % MOD

        return ans
