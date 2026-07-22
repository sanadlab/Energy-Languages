from typing import List

class Solution:
    def diStringMatch(self, s: str) -> List[int]:
        low, high = 0, len(s)
        perm = []
        
        for ch in s:
            if ch == 'I':
                perm.append(low)
                low += 1
            else:
                perm.append(high)
                high -= 1
        
        perm.append(low)
        return perm
