class Solution:
    def medianSlidingWindow(self, nums, k):
        res = []
        n = len(nums)
        for i in range(0, n - k + 1):
            w = sorted(nums[i:i+k])
            if k % 2 == 1:
                median = float(w[k // 2])
            else:
                median = (w[k//2 - 1] + w[k//2]) / 2.0
            res.append(median)
        return res
