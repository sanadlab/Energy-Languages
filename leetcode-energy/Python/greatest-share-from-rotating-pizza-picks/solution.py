from typing import List

class Solution:
    def maxSizeSlices(self, slices: List[int]) -> int:
        # We need to pick n slices out of 3n slices such that no two chosen slices are adjacent.
        # Because the pizza is circular, the first and last slices are adjacent.
        # So we solve two cases:
        # 1) Include slices[0] and exclude slices[-1]
        # 2) Exclude slices[0] and include slices[-1]
        # Then take the max of these two cases.
        
        n = len(slices) // 3
        
        def max_sum_linear(arr: List[int], n: int) -> int:
            # DP approach to pick n slices from linear array arr with no two adjacent
            length = len(arr)
            # dp[i][j]: max sum using first i slices, picking j slices, no two adjacent
            dp = [[0] * (n + 1) for _ in range(length + 1)]
            
            for i in range(1, length + 1):
                for j in range(1, min(i, n) + 1):
                    # If we pick arr[i-1], we cannot pick arr[i-2], so add dp[i-2][j-1]
                    pick = arr[i-1] + (dp[i-2][j-1] if i-2 >= 0 else 0)
                    # If we don't pick arr[i-1], dp[i-1][j]
                    not_pick = dp[i-1][j]
                    dp[i][j] = max(pick, not_pick)
            return dp[length][n]
        
        # Case 1: exclude last slice
        case1 = max_sum_linear(slices[:-1], n)
        # Case 2: exclude first slice
        case2 = max_sum_linear(slices[1:], n)
        
        return max(case1, case2)
