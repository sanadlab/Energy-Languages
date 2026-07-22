class Solution:
    def minimumTime(self, s: str) -> int:
        n = len(s)
        left_cost = 0
        ans = n
        
        for i, ch in enumerate(s):
            if ch == '1':
                left_cost = min(left_cost + 2, i + 1)
            ans = min(ans, left_cost + n - 1 - i)
        
        return ans
