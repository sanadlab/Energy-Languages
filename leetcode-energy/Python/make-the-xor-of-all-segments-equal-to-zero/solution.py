from typing import List
from collections import Counter

class Solution:
    def minChanges(self, nums: List[int], k: int) -> int:
        n = len(nums)
        MAX_XOR = 1 << 10
        NEG = -10**9

        dp = [NEG] * MAX_XOR
        dp[0] = 0

        for i in range(k):
            cnt = Counter()
            for j in range(i, n, k):
                cnt[nums[j]] += 1

            best = max(dp)
            ndp = [best] * MAX_XOR

            for val, freq in cnt.items():
                for x in range(MAX_XOR):
                    kept = dp[x] + freq
                    nx = x ^ val
                    if kept > ndp[nx]:
                        ndp[nx] = kept

            dp = ndp

        return n - dp[0]
