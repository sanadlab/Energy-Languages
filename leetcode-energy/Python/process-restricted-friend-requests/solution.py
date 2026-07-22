from typing import List

class Solution:
    def friendRequests(self, n: int, restrictions: List[List[int]], requests: List[List[int]]) -> List[bool]:
        parent = list(range(n))
        size = [1] * n
        
        def find(x: int) -> int:
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        def union(a: int, b: int) -> None:
            ra, rb = find(a), find(b)
            if ra == rb:
                return
            if size[ra] < size[rb]:
                ra, rb = rb, ra
            parent[rb] = ra
            size[ra] += size[rb]
        
        result = []
        
        for u, v in requests:
            ru, rv = find(u), find(v)
            
            if ru == rv:
                result.append(True)
                continue
            
            allowed = True
            
            for x, y in restrictions:
                rx, ry = find(x), find(y)
                if (rx == ru and ry == rv) or (rx == rv and ry == ru):
                    allowed = False
                    break
            
            if allowed:
                union(ru, rv)
                result.append(True)
            else:
                result.append(False)
        
        return result
