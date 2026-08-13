class Solution:
    def largestMagicSquare(self, grid: List[List[int]]) -> int:
        m, n = len(grid), len(grid[0])
        
        # Prefix sum matrix for rows and columns
        row_sums = [[0] * (n + 1) for _ in range(m)]
        col_sums = [[0] * (n + 1) for _ in range(m)]
        
        # Fill prefix sums
        for i in range(m):
            for j in range(n):
                row_sums[i][j+1] = row_sums[i][j] + grid[i][j]
                col_sums[i][j+1] = col_sums[i][j] + grid[i][j]

        # Function to check if a square is magic
        def is_magic_square(r, c, k):
            total = sum(grid[r+k-1][c:c+k])
            for i in range(k):
                row_sum = col_sum = 0
                for j in range(k):
                    row_sum += grid[r+i][c+j]
                    col_sum += grid[r+j][c+i]
                if row_sum != total or col_sum != total:
                    return False
            diag1, diag2 = 0, 0
            for i in range(k):
                diag1 += grid[r+i][c+i]
                diag2 += grid[r+k-1-i][c+i]
            return diag1 == total and diag2 == total

        # Check all possible square sizes from max(m, n) down to 2
        for k in range(min(m, n), 1, -1):
            for i in range(m - k + 1):
                for j in range(n - k + 1):
                    if is_magic_square(i, j, k):
                        return k

        return 1