from typing import List

class Solution:
    def canCross(self, stones: List[int]) -> bool:
        if stones[1] != 1:
            return False
        
        stone_set = set(stones)
        dp = {stone: set() for stone in stones}
        
        dp[1].add(1)
        
        for stone in stones:
            for k in dp[stone]:
                for step in [k - 1, k, k + 1]:
                    if step > 0 and stone + step in stone_set:
                        dp[stone + step].add(step)
        
        return bool(dp[stones[-1]])