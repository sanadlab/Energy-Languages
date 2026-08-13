class Solution:
    def maxSizeSlices(self, slices):
        def best(nums, k):
            n = len(nums)
            NEG = float('-inf')
            dp = [[NEG] * (k + 1) for _ in range(n + 1)]
            for i in range(n + 1):
                dp[i][0] = 0
            for i in range(1, n + 1):
                for j in range(1, k + 1):
                    skip = dp[i - 1][j]
                    if i >= 2:
                        prev = dp[i - 2][j - 1]
                    else:
                        prev = 0 if j == 1 else NEG
                    take = prev + nums[i - 1]
                    dp[i][j] = max(skip, take)
            return dp[n][k]

        total = len(slices)
        k = total // 3
        if k == 0:
            return 0
        return max(best(slices[:-1], k), best(slices[1:], k))
