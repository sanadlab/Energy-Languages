from typing import *

class Solution:
    def diStringMatch(self, s: str) -> List[int]:
        low, high = 0, len(s)
        perm = []
        for char in s:
            if char == 'I':
                perm.append(low)
                low += 1
            else:
                perm.append(high)
                high -= 1
        return perm + [low]