from typing import List

class Solution:
    def canCross(self, stones: List[int]) -> bool:
        stone_positions = set(stones)
        last_stone = stones[-1]
        # Dictionary to keep track of possible jump lengths that can land on each stone
        jumps = {stone: set() for stone in stones}
        jumps[0].add(0)  # Starting point, no jump needed to stand on first stone
        
        for stone in stones:
            for jump_length in jumps[stone]:
                # Next jumps can be k-1, k, or k+1 units
                for step in [jump_length - 1, jump_length, jump_length + 1]:
                    if step > 0:
                        next_pos = stone + step
                        if next_pos == last_stone:
                            return True
                        if next_pos in stone_positions:
                            jumps[next_pos].add(step)
        return False
