class Solution {
public:
    vector<vector<int>> shiftGrid(vector<vector<int>>& grid, int k) {
        int m = grid.size();
        int n = grid[0].size();
        int total = m * n;
        k = k % total;
        vector<vector<int>> res(m, vector<int>(n));
        
        for (int i = 0; i < m; ++i) {
            for (int j = 0; j < n; ++j) {
                int pos = i * n + j;
                int newPos = (pos + k) % total;
                int newRow = newPos / n;
                int newCol = newPos % n;
                res[newRow][newCol] = grid[i][j];
            }
        }
        return res;
    }
};