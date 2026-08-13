from typing import List


class Solution:
    def shiftGrid(self, grid: List[List[int]], k: int) -> List[List[int]]:
        m = len(grid)
        if m == 0:
            return grid
        n = len(grid[0])
        if n == 0:
            return grid
        total = m * n
        k %= total
        flat = [grid[i][j] for i in range(m) for j in range(n)]
        res = [[0] * n for _ in range(m)]
        for idx in range(total):
            np = (idx + k) % total
            res[np // n][np % n] = flat[idx]
        return res
