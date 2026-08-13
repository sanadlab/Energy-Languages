from math import sqrt

class Solution:
    def countTriples(self, n: int) -> int:
        count = 0
        for a in range(1, n + 1):
            for b in range(a, n + 1):  # Start from 'a' to avoid duplicate triples
                c_square = a * a + b * b
                c = int(sqrt(c_square))
                if c <= n and c * c == c_square:
                    count += 2  # Both (a, b, c) and (b, a, c) are valid
        return count