from typing import List

class Solution:
    def ambiguousCoordinates(self, s: str) -> List[str]:
        digits = s[1:-1]
        
        def valid_numbers(t: str) -> List[str]:
            res = []
            n = len(t)
            
            if n == 1 or t[0] != '0':
                res.append(t)
            
            for i in range(1, n):
                left, right = t[:i], t[i:]
                if (len(left) == 1 or left[0] != '0') and right[-1] != '0':
                    res.append(left + "." + right)
            
            return res
        
        ans = []
        for i in range(1, len(digits)):
            left_options = valid_numbers(digits[:i])
            right_options = valid_numbers(digits[i:])
            
            for x in left_options:
                for y in right_options:
                    ans.append(f"({x}, {y})")
        
        return ans
