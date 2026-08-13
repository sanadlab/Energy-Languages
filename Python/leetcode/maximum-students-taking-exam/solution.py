from typing import List

class Solution:
    def maxStudents(self, seats: List[List[str]]) -> int:
        m = len(seats)
        if m == 0:
            return 0
        n = len(seats[0])
        avail = [0] * m
        for i in range(m):
            for j in range(n):
                if j < len(seats[i]) and seats[i][j] == '.':
                    avail[i] |= (1 << j)
        full = 1 << n
        best = [-1] * full
        best[0] = 0
        for i in range(m):
            ndp = [-1] * full
            for mask in range(full):
                if (mask & avail[i]) != mask:
                    continue
                if mask & (mask << 1):
                    continue
                pc = bin(mask).count('1')
                for pmask in range(full):
                    if best[pmask] < 0:
                        continue
                    if mask & (pmask << 1):
                        continue
                    if mask & (pmask >> 1):
                        continue
                    val = best[pmask] + pc
                    if val > ndp[mask]:
                        ndp[mask] = val
            best = ndp
        return max(best)
