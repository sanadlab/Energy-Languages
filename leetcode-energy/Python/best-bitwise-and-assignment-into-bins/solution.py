from functools import lru_cache

class Solution:
    def maximumANDSum(self, nums: list[int], numSlots: int) -> int:
        n = len(nums)
        
        # Each slot can hold up to 2 numbers, so we represent the state as a base-3 number
        # with numSlots digits, each digit in {0,1,2} representing how many numbers are in that slot.
        # We'll use DP with memoization over (index, state).
        
        @lru_cache(None)
        def dp(i, state):
            if i == n:
                return 0
            
            max_sum = 0
            # Try to put nums[i] into any slot that has less than 2 numbers
            for slot in range(numSlots):
                count = (state // (3**slot)) % 3
                if count < 2:
                    new_state = state + (3**slot)
                    # slot labels are 1-based
                    val = (nums[i] & (slot + 1)) + dp(i+1, new_state)
                    if val > max_sum:
                        max_sum = val
            return max_sum
        
        return dp(0, 0)
