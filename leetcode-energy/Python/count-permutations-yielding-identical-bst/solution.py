from math import comb
from functools import lru_cache

class Solution:
    MOD = 10**9 + 7
    
    def numOfWays(self, nums: list[int]) -> int:
        # Precompute combinations with Pascal's triangle for efficiency
        n = len(nums)
        combs = [[0]*(n+1) for _ in range(n+1)]
        for i in range(n+1):
            combs[i][0] = 1
            for j in range(1, i+1):
                combs[i][j] = (combs[i-1][j-1] + combs[i-1][j]) % self.MOD
        
        def ways(arr):
            if len(arr) <= 2:
                return 1
            root = arr[0]
            left = [x for x in arr if x < root]
            right = [x for x in arr if x > root]
            left_ways = ways(left)
            right_ways = ways(right)
            # Number of ways to interleave left and right preserving their relative order
            return (combs[len(left)+len(right)][len(left)] * left_ways * right_ways) % self.MOD
        
        # The problem asks for number of reorderings excluding the original order
        return (ways(nums) - 1) % self.MOD
