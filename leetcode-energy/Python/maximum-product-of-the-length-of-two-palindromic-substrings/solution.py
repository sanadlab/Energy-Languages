from collections import deque

class Solution:
    def maxProduct(self, s: str) -> int:
        def odd_radii(t: str):
            n = len(t)
            d = [0] * n
            l, r = 0, -1
            
            for i in range(n):
                k = 1 if i > r else min(d[l + r - i], r - i + 1)
                
                while i - k >= 0 and i + k < n and t[i - k] == t[i + k]:
                    k += 1
                
                d[i] = k
                
                if i + k - 1 > r:
                    l = i - k + 1
                    r = i + k - 1
            
            return d
        
        def best_prefix(t: str):
            n = len(t)
            d = odd_radii(t)
            best = [0] * n
            q = deque()
            cur = 0
            
            for i in range(n):
                q.append((i, i + d[i] - 1))
                
                while q and q[0][1] < i:
                    q.popleft()
                
                length = 2 * (i - q[0][0]) + 1
                cur = max(cur, length)
                best[i] = cur
            
            return best
        
        n = len(s)
        left = best_prefix(s)
        rev_left = best_prefix(s[::-1])
        
        ans = 0
        for i in range(n - 1):
            ans = max(ans, left[i] * rev_left[n - 2 - i])
        
        return ans
