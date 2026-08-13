public class Solution {
    public int LargestMagicSquare(int[][] grid) {
        int m = grid.Length, n = grid[0].Length;
        
        // Prefix sums for rows and columns
        int[][] rowPrefix = new int[m][];
        int[][] colPrefix = new int[m][];
        for (int i = 0; i < m; i++) {
            rowPrefix[i] = new int[n + 1];
            colPrefix[i] = new int[n + 1];
        }
        
        // Build row prefix sums
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                rowPrefix[i][j + 1] = rowPrefix[i][j] + grid[i][j];
            }
        }
        
        // Build column prefix sums
        // We can reuse colPrefix as prefix sums for columns by transposing the logic
        // Actually, we need prefix sums for columns, so let's build colPrefix as colPrefix[j][i+1]
        // But since we declared colPrefix as m x (n+1), let's just build a separate colPrefix array
        int[][] colPrefixSum = new int[m + 1][];
        for (int i = 0; i <= m; i++) {
            colPrefixSum[i] = new int[n];
        }
        for (int j = 0; j < n; j++) {
            for (int i = 0; i < m; i++) {
                colPrefixSum[i + 1][j] = colPrefixSum[i][j] + grid[i][j];
            }
        }
        
        // To speed up diagonal sums, build prefix sums for diagonals:
        // diag1Prefix[i+1][j+1] = sum of grid[x][y] where x,y from (0,0) to (i,j) along main diagonal direction
        // diag2Prefix[i+1][j] = sum of grid[x][y] where x,y from (0,n-1) to (i,j) along anti-diagonal direction
        int[][] diag1Prefix = new int[m + 1][];
        int[][] diag2Prefix = new int[m + 1][];
        for (int i = 0; i <= m; i++) {
            diag1Prefix[i] = new int[n + 1];
            diag2Prefix[i] = new int[n + 1];
        }
        
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                diag1Prefix[i + 1][j + 1] = diag1Prefix[i][j] + grid[i][j];
                diag2Prefix[i + 1][j] = diag2Prefix[i][j + 1] + grid[i][j];
            }
        }
        
        int maxSize = 1;
        
        // Check from largest possible size to smallest
        int maxK = Math.Min(m, n);
        for (int k = maxK; k >= 2; k--) {
            bool found = false;
            for (int i = 0; i <= m - k; i++) {
                for (int j = 0; j <= n - k; j++) {
                    // sum of first row
                    int target = rowPrefix[i][j + k] - rowPrefix[i][j];
                    
                    bool magic = true;
                    
                    // check all rows
                    for (int r = i + 1; r < i + k; r++) {
                        int rowSum = rowPrefix[r][j + k] - rowPrefix[r][j];
                        if (rowSum != target) {
                            magic = false;
                            break;
                        }
                    }
                    if (!magic) continue;
                    
                    // check all columns
                    for (int c = j; c < j + k; c++) {
                        int colSum = colPrefixSum[i + k][c] - colPrefixSum[i][c];
                        if (colSum != target) {
                            magic = false;
                            break;
                        }
                    }
                    if (!magic) continue;
                    
                    // check main diagonal
                    int diag1Sum = diag1Prefix[i + k][j + k] - diag1Prefix[i][j];
                    if (diag1Sum != target) continue;
                    
                    // check anti diagonal
                    int diag2Sum = diag2Prefix[i + k][j] - diag2Prefix[i][j + k];
                    if (diag2Sum != target) continue;
                    
                    // all checks passed
                    maxSize = k;
                    found = true;
                    break;
                }
                if (found) break;
            }
            if (found) break;
        }
        
        return maxSize;
    }
}