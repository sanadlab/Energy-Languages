from typing import List

class Solution:
    def maxSumTwoNoOverlap(self, nums: List[int], firstLen: int, secondLen: int) -> int:
        n = len(nums)
        prefix = [0] * (n + 1)
        
        for i, num in enumerate(nums):
            prefix[i + 1] = prefix[i] + num
        
        def max_sum(left_len: int, right_len: int) -> int:
            best_left = 0
            ans = 0
            
            for right_start in range(left_len, n - right_len + 1):
                left_sum = prefix[right_start] - prefix[right_start - left_len]
                best_left = max(best_left, left_sum)
                
                right_sum = prefix[right_start + right_len] - prefix[right_start]
                ans = max(ans, best_left + right_sum)
            
            return ans
        
        return max(
            max_sum(firstLen, secondLen),
            max_sum(secondLen, firstLen)
        )
