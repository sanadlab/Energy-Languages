class Solution:
    def maximumANDSum(self, nums, numSlots):
        n = len(nums)
        full = (1 << n) - 1
        dp = [-1] * (1 << n)
        dp[0] = 0
        for slot in range(1, numSlots + 1):
            ndp = dp[:]
            for mask in range(1 << n):
                if dp[mask] < 0:
                    continue
                base = dp[mask]
                for i in range(n):
                    if (mask >> i) & 1:
                        continue
                    nm = mask | (1 << i)
                    v = base + (nums[i] & slot)
                    if v > ndp[nm]:
                        ndp[nm] = v
                    for j in range(i + 1, n):
                        if (mask >> j) & 1:
                            continue
                        nm2 = nm | (1 << j)
                        v2 = v + (nums[j] & slot)
                        if v2 > ndp[nm2]:
                            ndp[nm2] = v2
            dp = ndp
        return dp[full] if dp[full] >= 0 else 0
