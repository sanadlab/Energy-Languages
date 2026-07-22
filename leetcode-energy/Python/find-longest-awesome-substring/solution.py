class Solution:
    def longestAwesome(self, s: str) -> int:
        first = [10**9] * 1024
        first[0] = -1
        
        mask = 0
        ans = 0
        
        for i, ch in enumerate(s):
            mask ^= 1 << (ord(ch) - ord('0'))
            
            ans = max(ans, i - first[mask])
            
            for d in range(10):
                ans = max(ans, i - first[mask ^ (1 << d)])
            
            if first[mask] == 10**9:
                first[mask] = i
        
        return ans
