from typing import List

class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        # Count soldiers in each row (since soldiers are all 1s on the left, count of 1s is sum)
        # Pair each count with the row index
        soldier_counts = [(sum(row), i) for i, row in enumerate(mat)]
        # Sort by soldier count, then by row index
        soldier_counts.sort(key=lambda x: (x[0], x[1]))
        # Extract the first k indices
        return [idx for _, idx in soldier_counts[:k]]
