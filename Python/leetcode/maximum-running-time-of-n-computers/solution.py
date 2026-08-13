from typing import List

class Solution:
    def maxRunTime(self, n: int, batteries: List[int]) -> int:
        total = sum(batteries)
        lo, hi = 0, total // n
        while lo < hi:
            mid = (lo + hi + 1) // 2
            avail = sum(min(b, mid) for b in batteries)
            if avail >= n * mid:
                lo = mid
            else:
                hi = mid - 1
        return lo
