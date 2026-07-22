from typing import List

class Solution:
    def sumOddLengthSubarrays(self, arr: List[int]) -> int:
        n = len(arr)
        total_sum = 0
        
        for i, num in enumerate(arr):
            total_subarrays = (i + 1) * (n - i)
            odd_subarrays = (total_subarrays + 1) // 2
            total_sum += num * odd_subarrays
        
        return total_sum
