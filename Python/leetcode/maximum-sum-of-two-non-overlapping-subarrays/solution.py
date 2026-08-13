from typing import List

class Solution:
    def maxSumTwoNoOverlap(self, nums: List[int], firstLen: int, secondLen: int) -> int:
        n = len(nums)
        pre = [0] * (n + 1)
        for i in range(n):
            pre[i + 1] = pre[i] + nums[i]

        def best(L, M):
            res = maxL = 0
            for i in range(L + M, n + 1):
                maxL = max(maxL, pre[i - M] - pre[i - M - L])
                res = max(res, maxL + pre[i] - pre[i - M])
            return res

        return max(best(firstLen, secondLen), best(secondLen, firstLen))
