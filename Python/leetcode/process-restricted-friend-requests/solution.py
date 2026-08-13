class Solution:
    def friendRequests(self, n, restrictions, requests):
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        res = []
        for u, v in requests:
            pu, pv = find(u), find(v)
            if pu == pv:
                res.append(True)
                continue
            ok = True
            for x, y in restrictions:
                px, py = find(x), find(y)
                if (px == pu and py == pv) or (px == pv and py == pu):
                    ok = False
                    break
            if ok:
                parent[pu] = pv
                res.append(True)
            else:
                res.append(False)
        return res
