from typing import List
from bisect import bisect_left, bisect_right

class Solution:
    def kthSmallestProduct(self, nums1: List[int], nums2: List[int], k: int) -> int:
        if len(nums1) > len(nums2):
            nums1, nums2 = nums2, nums1

        m = len(nums2)
        br = bisect_right
        bl = bisect_left

        def count_le(x: int) -> int:
            total = 0
            for a in nums1:
                if a > 0:
                    total += br(nums2, x // a)
                elif a < 0:
                    total += m - bl(nums2, -((-x) // a))
                else:
                    if x >= 0:
                        total += m

                if total >= k:
                    return total

            return total

        left, right = -10**10, 10**10

        while left < right:
            mid = (left + right) // 2
            if count_le(mid) >= k:
                right = mid
            else:
                left = mid + 1

        return left
