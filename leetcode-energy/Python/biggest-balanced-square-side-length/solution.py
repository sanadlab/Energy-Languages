class Solution:
    def largestMagicSquare(self, grid: list[list[int]]) -> int:
        m, n = len(grid), len(grid[0])
        
        # Prefix sums for rows and columns
        row_prefix = [[0]*(n+1) for _ in range(m)]
        col_prefix = [[0]*(n) for _ in range(m+1)]
        
        for i in range(m):
            for j in range(n):
                row_prefix[i][j+1] = row_prefix[i][j] + grid[i][j]
                col_prefix[i+1][j] = col_prefix[i][j] + grid[i][j]
        
        def get_row_sum(r, c1, c2):
            return row_prefix[r][c2+1] - row_prefix[r][c1]
        
        def get_col_sum(c, r1, r2):
            return col_prefix[r2+1][c] - col_prefix[r1][c]
        
        # Check if k x k magic square with top-left corner at (r,c)
        def is_magic(r, c, k):
            # sum of first row
            target = get_row_sum(r, c, c+k-1)
            
            # check all rows
            for i in range(r, r+k):
                if get_row_sum(i, c, c+k-1) != target:
                    return False
            
            # check all columns
            for j in range(c, c+k):
                if get_col_sum(j, r, r+k-1) != target:
                    return False
            
            # check main diagonal
            diag1 = 0
            for i in range(k):
                diag1 += grid[r+i][c+i]
            if diag1 != target:
                return False
            
            # check anti diagonal
            diag2 = 0
            for i in range(k):
                diag2 += grid[r+i][c+k-1-i]
            if diag2 != target:
                return False
            
            return True
        
        max_side = 1
        # Try from largest possible k down to 1 for early stopping
        max_k = min(m, n)
        for k in range(max_k, 1, -1):
            for r in range(m - k + 1):
                for c in range(n - k + 1):
                    if is_magic(r, c, k):
                        return k
        return 1
