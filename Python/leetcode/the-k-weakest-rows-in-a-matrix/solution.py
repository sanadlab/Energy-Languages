from typing import List

class Solution:
    def kWeakestRows(self, mat: List[List[int]], k: int) -> List[int]:
        # Count soldiers in each row and store the count with the row index
        counts = [(sum(row), i) for i, row in enumerate(mat)]
        
        # Sort rows based on the number of soldiers, then by index if counts are equal
        counts.sort()
        
        # Extract the indices of the k weakest rows
        return [index for _, index in counts[:k]]