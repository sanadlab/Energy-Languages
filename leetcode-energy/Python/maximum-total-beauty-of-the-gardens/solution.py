from typing import List
from bisect import bisect_left, bisect_right

class Solution:
    def maximumBeauty(self, flowers: List[int], newFlowers: int, target: int, full: int, partial: int) -> int:
        n = len(flowers)
        arr = sorted(min(x, target) for x in flowers)

        prefix = [0] * (n + 1)
        for i, x in enumerate(arr):
            prefix[i + 1] = prefix[i] + x

        first_complete = bisect_left(arr, target)
        already_complete = n - first_complete

        ans = 0

        for complete in range(already_complete, n + 1):
            suffix_sum = prefix[n] - prefix[n - complete]
            cost_complete = complete * target - suffix_sum

            if cost_complete > newFlowers:
                break

            remaining = newFlowers - cost_complete
            incomplete = n - complete

            beauty = complete * full

            if incomplete > 0:
                lo, hi = 0, target - 1

                while lo < hi:
                    mid = (lo + hi + 1) // 2
                    cnt = bisect_right(arr, mid, 0, incomplete)
                    cost = mid * cnt - prefix[cnt]

                    if cost <= remaining:
                        lo = mid
                    else:
                        hi = mid - 1

                beauty += lo * partial

            ans = max(ans, beauty)

        return ans
