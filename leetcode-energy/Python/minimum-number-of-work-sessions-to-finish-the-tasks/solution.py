from typing import List

class Solution:
    def minSessions(self, tasks: List[int], sessionTime: int) -> int:
        n = len(tasks)
        total_masks = 1 << n
        
        dp = [(n + 1, 0)] * total_masks
        dp[0] = (1, 0)
        
        for mask in range(total_masks):
            sessions, used = dp[mask]
            
            for i in range(n):
                if mask & (1 << i):
                    continue
                
                task = tasks[i]
                next_mask = mask | (1 << i)
                
                if used + task <= sessionTime:
                    candidate = (sessions, used + task)
                else:
                    candidate = (sessions + 1, task)
                
                if candidate[0] < dp[next_mask][0] or (
                    candidate[0] == dp[next_mask][0] and candidate[1] < dp[next_mask][1]
                ):
                    dp[next_mask] = candidate
        
        return dp[total_masks - 1][0]
