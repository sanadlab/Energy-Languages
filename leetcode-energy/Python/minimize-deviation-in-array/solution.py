from typing import List
import heapq

class Solution:
    def minimumDeviation(self, nums: List[int]) -> int:
        heap = []
        min_val = float('inf')

        for x in nums:
            if x % 2 == 1:
                x *= 2
            min_val = min(min_val, x)
            heapq.heappush(heap, -x)

        ans = float('inf')

        while True:
            max_val = -heapq.heappop(heap)
            ans = min(ans, max_val - min_val)

            if max_val % 2 == 1:
                break

            next_val = max_val // 2
            min_val = min(min_val, next_val)
            heapq.heappush(heap, -next_val)

        return ans
