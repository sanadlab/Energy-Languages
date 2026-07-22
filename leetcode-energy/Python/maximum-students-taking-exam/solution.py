from typing import List

class Solution:
    def maxStudents(self, seats: List[List[str]]) -> int:
        m, n = len(seats), len(seats[0])
        
        row_masks = []
        for i in range(m):
            mask = 0
            for j in range(n):
                if seats[i][j] == '.':
                    mask |= 1 << j
            row_masks.append(mask)
        
        valid_masks = []
        bit_counts = {}
        for mask in range(1 << n):
            if mask & (mask << 1) == 0:
                valid_masks.append(mask)
                bit_counts[mask] = mask.bit_count()
        
        dp = {0: 0}
        
        for i in range(m):
            new_dp = {}
            available = row_masks[i]
            
            for curr in valid_masks:
                if curr & ~available:
                    continue
                
                curr_count = bit_counts[curr]
                
                for prev, prev_val in dp.items():
                    if curr & (prev << 1):
                        continue
                    if curr & (prev >> 1):
                        continue
                    
                    new_dp[curr] = max(new_dp.get(curr, 0), prev_val + curr_count)
            
            dp = new_dp
        
        return max(dp.values())
