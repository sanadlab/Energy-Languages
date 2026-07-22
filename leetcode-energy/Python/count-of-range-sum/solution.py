from typing import List
from bisect import bisect_left, bisect_right

class Solution:
    def countRangeSum(self, nums: List[int], lower: int, upper: int) -> int:
        prefix = [0]
        total = 0
        for x in nums:
            total += x
            prefix.append(total)

        coords = sorted(set(prefix))
        rank = {v: i + 1 for i, v in enumerate(coords)}
        m = len(coords)
        bit = [0] * (m + 1)

        def query(i: int) -> int:
            res = 0
            while i > 0:
                res += bit[i]
                i -= i & -i
            return res

        ans = 0

        for s in prefix:
            left = bisect_left(coords, s - upper)
            right = bisect_right(coords, s - lower)
            ans += query(right) - query(left)

            i = rank[s]
            while i <= m:
                bit[i] += 1
                i += i & -i

        return ans
