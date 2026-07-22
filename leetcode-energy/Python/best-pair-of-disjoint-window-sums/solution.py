from typing import List

class Solution:
    def maxSumTwoNoOverlap(self, nums: List[int], firstLen: int, secondLen: int) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        for i in range(n):
            prefix[i+1] = prefix[i] + nums[i]

        def max_sum_with_order(L, M):
            max_L = 0
            res = 0
            # i is the start of M-length subarray
            for i in range(L, n - M + 1):
                # max sum of L-length subarray ending before i
                max_L = max(max_L, prefix[i] - prefix[i - L])
                # sum of M-length subarray starting at i
                M_sum = prefix[i + M] - prefix[i]
                res = max(res, max_L + M_sum)
            return res

        # Try both orders: firstLen before secondLen, and secondLen before firstLen
        return max(max_sum_with_order(firstLen, secondLen), max_sum_with_order(secondLen, firstLen))
