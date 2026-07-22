from typing import List

class Solution:
    def countTriplets(self, nums: List[int]) -> int:
        bits = max(nums).bit_length()
        size = 1 << bits
        full = size - 1
        
        pair_and_count = [0] * size
        
        for a in nums:
            for b in nums:
                pair_and_count[a & b] += 1
        
        for bit in range(bits):
            step = 1 << bit
            for base in range(0, size, step << 1):
                for mask in range(base + step, base + (step << 1)):
                    pair_and_count[mask] += pair_and_count[mask - step]
        
        return sum(pair_and_count[full ^ x] for x in nums)
