class Solution:
    def friendRequests(self, n: int, restrictions: list[list[int]], requests: list[list[int]]) -> list[bool]:
        parent = list(range(n))
        size = [1] * n
        
        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x
        
        def union(a, b):
            a = find(a)
            b = find(b)
            if a == b:
                return
            if size[a] < size[b]:
                a, b = b, a
            parent[b] = a
            size[a] += size[b]
        
        res = []
        for u, v in requests:
            pu, pv = find(u), find(v)
            if pu == pv:
                # Already friends, request successful
                res.append(True)
                continue
            
            # Check if union would violate any restriction
            can_union = True
            for x, y in restrictions:
                px, py = find(x), find(y)
                # If after union pu and pv would be in same set,
                # and px and py are in different sets,
                # but union would connect them indirectly, it's forbidden.
                # More precisely, if one of px or py equals pu or pv,
                # and the other equals the other root, then restriction violated.
                if (px == pu and py == pv) or (px == pv and py == pu):
                    can_union = False
                    break
            
            if can_union:
                union(pu, pv)
                res.append(True)
            else:
                res.append(False)
        
        return res
