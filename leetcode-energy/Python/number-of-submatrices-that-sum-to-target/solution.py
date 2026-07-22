from typing import List
from collections import defaultdict

class Solution:
    def numSubmatrixSumTarget(self, matrix: List[List[int]], target: int) -> int:
        m, n = len(matrix), len(matrix[0])
        ans = 0

        if m <= n:
            for top in range(m):
                col_sums = [0] * n
                for bottom in range(top, m):
                    for c in range(n):
                        col_sums[c] += matrix[bottom][c]

                    freq = defaultdict(int)
                    freq[0] = 1
                    prefix = 0

                    for val in col_sums:
                        prefix += val
                        ans += freq[prefix - target]
                        freq[prefix] += 1
        else:
            for left in range(n):
                row_sums = [0] * m
                for right in range(left, n):
                    for r in range(m):
                        row_sums[r] += matrix[r][right]

                    freq = defaultdict(int)
                    freq[0] = 1
                    prefix = 0

                    for val in row_sums:
                        prefix += val
                        ans += freq[prefix - target]
                        freq[prefix] += 1

        return ans
