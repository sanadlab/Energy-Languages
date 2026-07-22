from bisect import bisect_left, bisect_right
from itertools import accumulate

class Solution:
    def maxTotalFruits(self, fruits: list[list[int]], startPos: int, k: int) -> int:
        # Extract positions and amounts separately
        positions = [pos for pos, _ in fruits]
        amounts = [amt for _, amt in fruits]
        # Prefix sums of amounts for O(1) range sum queries
        prefix = [0] + list(accumulate(amounts))
        
        n = len(fruits)
        
        def get_sum(l_idx, r_idx):
            # sum of fruits from l_idx to r_idx inclusive
            if l_idx > r_idx:
                return 0
            return prefix[r_idx+1] - prefix[l_idx]
        
        max_fruits = 0
        
        # We consider two main movement patterns:
        # 1) Move left first, then right
        # 2) Move right first, then left
        
        # For each possible left boundary, find the max right boundary reachable within k steps
        # and vice versa.
        
        # Since fruits are sorted by position, we can binary search indices for intervals.
        
        # We'll try all possible intervals [left, right] that can be covered within k steps starting at startPos.
        # The cost to cover [left, right] depends on startPos position relative to left and right:
        # - If startPos <= left: cost = right - startPos
        # - If startPos >= right: cost = startPos - left
        # - If left < startPos < right: cost = min( (startPos - left)*2 + (right - startPos),
        #                                           (right - startPos)*2 + (startPos - left) )
        # Explanation:
        # You can go to one side first, then the other side.
        # The cost is the minimal steps to cover the whole interval starting at startPos.
        
        # We'll iterate over all possible intervals using two pointers.
        
        # To optimize, we fix one side and move the other side with two pointers.
        
        # We'll try all intervals [i, j] with i <= j.
        
        # Use two pointers approach:
        j = 0
        for i in range(n):
            # Move j as far right as possible while cost <= k
            while j < n:
                left_pos = positions[i]
                right_pos = positions[j]
                if startPos <= left_pos:
                    cost = right_pos - startPos
                elif startPos >= right_pos:
                    cost = startPos - left_pos
                else:
                    cost = min((startPos - left_pos)*2 + (right_pos - startPos),
                               (right_pos - startPos)*2 + (startPos - left_pos))
                if cost <= k:
                    j += 1
                else:
                    break
            # j is now one past the valid interval end
            # sum fruits in [i, j-1]
            max_fruits = max(max_fruits, get_sum(i, j-1))
            # Move i forward, j will not move backward, so no need to adjust j here
        
        return max_fruits
