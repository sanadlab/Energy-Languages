from functools import lru_cache

class Solution:
    def minSessions(self, tasks: list[int], sessionTime: int) -> int:
        n = len(tasks)
        full_mask = (1 << n) - 1
        
        # Precompute the sum of durations for all subsets of tasks
        subset_sum = [0] * (1 << n)
        for mask in range(1 << n):
            s = 0
            for i in range(n):
                if mask & (1 << i):
                    s += tasks[i]
            subset_sum[mask] = s
        
        # dp[mask] = minimum number of sessions needed to finish tasks in mask
        # We'll use top-down DP with memoization
        @lru_cache(None)
        def dp(mask):
            if mask == 0:
                return 0
            # Initialize with max possible sessions (worst case: one task per session)
            res = n
            sub = mask
            # Enumerate all subsets of mask
            # We only consider subsets whose sum <= sessionTime
            while sub:
                if subset_sum[sub] <= sessionTime:
                    # If we do tasks in 'sub' in one session,
                    # then solve for remaining tasks mask ^ sub
                    res = min(res, 1 + dp(mask ^ sub))
                sub = (sub - 1) & mask
            return res
        
        return dp(full_mask)
