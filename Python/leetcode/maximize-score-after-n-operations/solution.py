from math import gcd

class Solution:
    def maxScore(self, nums):
        m = len(nums)
        dp = [0] * (1 << m)
        best = 0
        for mask in range(1 << m):
            cnt = bin(mask).count('1')
            if cnt & 1:
                continue
            op = cnt // 2 + 1
            for i in range(m):
                if (mask >> i) & 1:
                    continue
                for j in range(i + 1, m):
                    if (mask >> j) & 1:
                        continue
                    nm = mask | (1 << i) | (1 << j)
                    val = dp[mask] + op * gcd(nums[i], nums[j])
                    if val > dp[nm]:
                        dp[nm] = val
                        if val > best:
                            best = val
        return best
