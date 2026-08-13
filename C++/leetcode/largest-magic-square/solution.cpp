class Solution {
public:
    int largestMagicSquare(vector<vector<int>>& grid) {
        int m = grid.size(), n = grid[0].size();
        // Prefix sums for rows and columns
        vector<vector<int>> rowPrefix(m, vector<int>(n+1, 0));
        vector<vector<int>> colPrefix(m+1, vector<int>(n, 0));
        
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                rowPrefix[i][j+1] = rowPrefix[i][j] + grid[i][j];
                colPrefix[i+1][j] = colPrefix[i][j] + grid[i][j];
            }
        }
        
        // Check if k x k magic square exists starting at (r,c)
        auto isMagic = [&](int r, int c, int k) -> bool {
            int diag1 = 0, diag2 = 0;
            for (int i = 0; i < k; ++i) {
                diag1 += grid[r+i][c+i];
                diag2 += grid[r+i][c+k-1-i];
            }
            if (diag1 != diag2) return false;
            
            // Check rows sums
            for (int i = 0; i < k; ++i) {
                int rowSum = rowPrefix[r+i][c+k] - rowPrefix[r+i][c];
                if (rowSum != diag1) return false;
            }
            // Check columns sums
            for (int j = 0; j < k; ++j) {
                int colSum = colPrefix[r+k][c+j] - colPrefix[r][c+j];
                if (colSum != diag1) return false;
            }
            return true;
        };
        
        int maxK = min(m,n);
        for (int k = maxK; k >= 1; --k) {
            for (int r = 0; r <= m - k; ++r) {
                for (int c = 0; c <= n - k; ++c) {
                    if (isMagic(r,c,k)) return k;
                }
            }
        }
        return 1; // At least 1x1 is always magic
    }
};