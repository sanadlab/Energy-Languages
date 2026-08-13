from typing import List


class Solution:
    def ambiguousCoordinates(self, s: str) -> List[str]:
        digits = s[1:-1]
        n = len(digits)
        res = []
        for i in range(1, n):
            for a in self.make(digits[:i]):
                for b in self.make(digits[i:]):
                    res.append("(%s, %s)" % (a, b))
        return res

    def make(self, d):
        out = []
        n = len(d)
        if n == 1:
            out.append(d)
            return out
        if d[0] != '0':
            out.append(d)
        for i in range(1, n):
            l, r = d[:i], d[i:]
            if (l == "0" or l[0] != '0') and r[-1] != '0':
                out.append(l + "." + r)
        return out
