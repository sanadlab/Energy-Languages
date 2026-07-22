from typing import List

class Solution:
    def createSortedArray(self, instructions: List[int]) -> int:
        MOD = 10**9 + 7
        n = max(instructions) + 2
        bit = [0] * (n + 1)

        def update(i: int, delta: int) -> None:
            while i <= n:
                bit[i] += delta
                i += i & -i

        def query(i: int) -> int:
            total = 0
            while i > 0:
                total += bit[i]
                i -= i & -i
            return total

        ans = 0
        for i, x in enumerate(instructions):
            less = query(x - 1)
            greater = i - query(x)
            ans = (ans + min(less, greater)) % MOD
            update(x, 1)

        return ans
