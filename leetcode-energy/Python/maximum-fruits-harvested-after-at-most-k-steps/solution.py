from typing import List

class Solution:
    def maxTotalFruits(self, fruits: List[List[int]], startPos: int, k: int) -> int:
        def steps(left_pos: int, right_pos: int) -> int:
            return right_pos - left_pos + min(abs(startPos - left_pos), abs(startPos - right_pos))
        
        ans = 0
        cur = 0
        left = 0
        
        for right in range(len(fruits)):
            cur += fruits[right][1]
            
            while left <= right and steps(fruits[left][0], fruits[right][0]) > k:
                cur -= fruits[left][1]
                left += 1
            
            ans = max(ans, cur)
        
        return ans
