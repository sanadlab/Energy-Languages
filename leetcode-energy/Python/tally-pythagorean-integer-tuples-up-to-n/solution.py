class Solution:
    def countTriples(self, n: int) -> int:
        count = 0
        for c in range(1, n+1):
            c2 = c*c
            for a in range(1, c):
                b2 = c2 - a*a
                b = int(b2**0.5)
                if b*b == b2 and b <= n and b >= 1:
                    count += 1
        return count
