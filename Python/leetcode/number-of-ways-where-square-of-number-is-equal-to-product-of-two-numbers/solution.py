from typing import List


class Solution:
    def _helper(self, a: List[int], b: List[int]) -> int:
        cnt = 0
        for x in a:
            t = x * x
            seen = {}
            for y in b:
                if t % y == 0:
                    need = t // y
                    cnt += seen.get(need, 0)
                seen[y] = seen.get(y, 0) + 1
        return cnt

    def numTriplets(self, nums1: List[int], nums2: List[int]) -> int:
        return self._helper(nums1, nums2) + self._helper(nums2, nums1)
