from typing import List

class Solution:
    def largestCheatFreeSeating(self, seats: List[List[str]]) -> int:
        m, n = len(seats), len(seats[0])
        
        # Precompute valid seat masks for each row
        valid_masks = []
        for r in range(m):
            mask = 0
            for c in range(n):
                if seats[r][c] == '.':
                    mask |= (1 << c)
            valid_masks.append(mask)
        
        # Generate all valid seatings for a row (no two adjacent students)
        def valid_row_seatings(row_mask):
            res = []
            # Iterate over all subsets of row_mask
            # and check no two adjacent bits set
            subset = row_mask
            while True:
                # Check no two adjacent bits set in subset
                if (subset & (subset >> 1)) == 0:
                    res.append(subset)
                if subset == 0:
                    break
                subset = (subset - 1) & row_mask
            return res
        
        # Check if two seatings in adjacent rows are compatible (no cheating)
        # Cheating occurs if a student can glimpse immediate left/right in same row,
        # or upper-left or upper-right diagonal in the row above.
        # We already ensure no two adjacent in same row.
        # Now check no conflicts between current row and previous row:
        # For each student in current row at position c:
        #   no student in previous row at c-1 or c+1
        def compatible(prev_mask, curr_mask):
            # Check upper-left diagonal: prev_mask shifted right by 1
            if (prev_mask >> 1) & curr_mask:
                return False
            # Check upper-right diagonal: prev_mask shifted left by 1
            if (prev_mask << 1) & curr_mask:
                return False
            return True
        
        # DP: dp[row][mask] = max students seated up to row with seating mask
        dp = [{} for _ in range(m)]
        
        first_row_seatings = valid_row_seatings(valid_masks[0])
        for mask in first_row_seatings:
            dp[0][mask] = bin(mask).count('1')
        
        for r in range(1, m):
            curr_seatings = valid_row_seatings(valid_masks[r])
            for curr_mask in curr_seatings:
                curr_count = bin(curr_mask).count('1')
                for prev_mask, prev_count in dp[r-1].items():
                    if compatible(prev_mask, curr_mask):
                        dp[r][curr_mask] = max(dp[r].get(curr_mask, 0), prev_count + curr_count)
        
        if m == 1:
            return max(dp[0].values()) if dp[0] else 0
        else:
            return max(dp[m-1].values()) if dp[m-1] else 0
