from typing import List
import heapq
from collections import defaultdict

class Solution:
    def medianSlidingWindow(self, nums: List[int], k: int) -> List[float]:
        small = []
        large = []
        delayed = defaultdict(int)
        small_size = 0
        large_size = 0

        def prune(heap, is_small):
            while heap:
                num = -heap[0] if is_small else heap[0]
                if delayed[num] == 0:
                    break
                delayed[num] -= 1
                if delayed[num] == 0:
                    del delayed[num]
                heapq.heappop(heap)

        def balance():
            nonlocal small_size, large_size

            if small_size > large_size + 1:
                heapq.heappush(large, -heapq.heappop(small))
                small_size -= 1
                large_size += 1
                prune(small, True)
            elif small_size < large_size:
                heapq.heappush(small, -heapq.heappop(large))
                large_size -= 1
                small_size += 1
                prune(large, False)

        def add(num):
            nonlocal small_size, large_size

            if not small or num <= -small[0]:
                heapq.heappush(small, -num)
                small_size += 1
            else:
                heapq.heappush(large, num)
                large_size += 1

            balance()

        def remove(num):
            nonlocal small_size, large_size

            delayed[num] += 1

            if num <= -small[0]:
                small_size -= 1
                if num == -small[0]:
                    prune(small, True)
            else:
                large_size -= 1
                if large and num == large[0]:
                    prune(large, False)

            balance()

        def get_median():
            if k % 2 == 1:
                return float(-small[0])
            return (-small[0] + large[0]) / 2.0

        result = []

        for i in range(k):
            add(nums[i])

        result.append(get_median())

        for i in range(k, len(nums)):
            add(nums[i])
            remove(nums[i - k])
            result.append(get_median())

        return result
