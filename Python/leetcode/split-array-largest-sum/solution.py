class Solution:
    def splitArray(self, nums, k):
        lo, hi = max(nums), sum(nums)
        while lo < hi:
            mid = (lo + hi) // 2
            cnt, cur = 1, 0
            for x in nums:
                if cur + x > mid:
                    cnt += 1
                    cur = x
                else:
                    cur += x
            if cnt <= k:
                hi = mid
            else:
                lo = mid + 1
        return lo
