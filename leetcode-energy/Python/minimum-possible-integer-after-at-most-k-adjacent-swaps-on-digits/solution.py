from collections import deque
from typing import List

class Solution:
    def minInteger(self, num: str, k: int) -> str:
        n = len(num)
        positions = [deque() for _ in range(10)]
        
        for i, ch in enumerate(num):
            positions[ord(ch) - ord('0')].append(i)
        
        bit = [0] * (n + 1)
        
        def add(i: int, val: int) -> None:
            while i <= n:
                bit[i] += val
                i += i & -i
        
        def query(i: int) -> int:
            total = 0
            while i > 0:
                total += bit[i]
                i -= i & -i
            return total
        
        ans = []
        
        for _ in range(n):
            for d in range(10):
                if positions[d]:
                    idx = positions[d][0]
                    removed_before = query(idx)
                    cost = idx - removed_before
                    
                    if cost <= k:
                        k -= cost
                        ans.append(str(d))
                        positions[d].popleft()
                        add(idx + 1, 1)
                        break
        
        return ''.join(ans)
