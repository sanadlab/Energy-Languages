from typing import List
from bisect import bisect_left

class Solution:
    def maximumBeauty(self, flowers: List[int], newFlowers: int, target: int, full: int, partial: int) -> int:
        n = len(flowers)
        if n == 0:
            return 0
        fl = sorted(min(f, target) for f in flowers)
        pre = [0] * (n + 1)
        for i in range(n):
            pre[i + 1] = pre[i] + fl[i]
        if fl[0] == target:
            return full * n
        ans = 0
        for i in range(n, -1, -1):
            cost_complete = target * (n - i) - (pre[n] - pre[i])
            if cost_complete > newFlowers:
                continue
            rem = newFlowers - cost_complete
            if i == 0:
                ans = max(ans, full * (n - i))
                continue
            lo, hi, best_min = 0, target - 1, 0
            while lo <= hi:
                v = (lo + hi) // 2
                k = bisect_left(fl, v, 0, i)
                cost = v * k - pre[k]
                if cost <= rem:
                    best_min = v
                    lo = v + 1
                else:
                    hi = v - 1
            ans = max(ans, full * (n - i) + best_min * partial)
        return ans
