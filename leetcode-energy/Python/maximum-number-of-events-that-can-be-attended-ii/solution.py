from bisect import bisect_right
from typing import List

class Solution:
    def maxValue(self, events: List[List[int]], k: int) -> int:
        n = len(events)
        
        if k == 1:
            return max(event[2] for event in events)
        
        events.sort(key=lambda x: x[0])
        starts = [event[0] for event in events]
        
        prev = [0] * (n + 1)
        
        for _ in range(k):
            curr = [0] * (n + 1)
            
            for i in range(n - 1, -1, -1):
                next_i = bisect_right(starts, events[i][1])
                take = events[i][2] + prev[next_i]
                skip = curr[i + 1]
                curr[i] = take if take > skip else skip
            
            prev = curr
        
        return prev[0]
