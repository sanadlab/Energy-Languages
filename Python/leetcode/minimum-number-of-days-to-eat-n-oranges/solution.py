class Solution:
    def minDays(self, n: int) -> int:
        memo = {}
        def solve(x):
            if x <= 1:
                return x
            if x in memo:
                return memo[x]
            res = 1 + min(x % 2 + solve(x // 2), x % 3 + solve(x // 3))
            memo[x] = res
            return res
        return solve(n)
