class Solution:
    def minDays(self, n: int) -> int:
        from functools import lru_cache
        
        @lru_cache(None)
        def dfs(x):
            if x <= 1:
                return x
            # Eat oranges to make x divisible by 2 or 3, then use the division moves
            # Option 1: eat (x % 2) oranges one by one, then eat half of the rest
            days_div2 = (x % 2) + 1 + dfs(x // 2)
            # Option 2: eat (x % 3) oranges one by one, then eat 2/3 of the rest
            days_div3 = (x % 3) + 1 + dfs(x // 3)
            return min(days_div2, days_div3)
        
        return dfs(n)
