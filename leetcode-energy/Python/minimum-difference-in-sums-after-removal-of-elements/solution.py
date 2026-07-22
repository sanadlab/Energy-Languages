from typing import List
import heapq

class Solution:
    def minimumDifference(self, nums: List[int]) -> int:
        m = len(nums)
        n = m // 3

        left = [0] * m
        max_heap = []
        total = 0

        for i in range(2 * n):
            total += nums[i]
            heapq.heappush(max_heap, -nums[i])

            if len(max_heap) > n:
                total += heapq.heappop(max_heap)

            if len(max_heap) == n:
                left[i] = total

        right = [0] * m
        min_heap = []
        total = 0

        for i in range(m - 1, n - 1, -1):
            total += nums[i]
            heapq.heappush(min_heap, nums[i])

            if len(min_heap) > n:
                total -= heapq.heappop(min_heap)

            if len(min_heap) == n:
                right[i] = total

        ans = float("inf")

        for i in range(n - 1, 2 * n):
            ans = min(ans, left[i] - right[i + 1])

        return ans
