class Solution {
public:
    int rows, cols;
    int minDays(vector<vector<int>>& grid) {
        rows = grid.size();
        cols = grid[0].size();
        if (countIslands(grid) != 1) return 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (grid[i][j] == 1) {
                    grid[i][j] = 0;
                    if (countIslands(grid) != 1) { grid[i][j] = 1; return 1; }
                    grid[i][j] = 1;
                }
            }
        }
        return 2;
    }
    int countIslands(vector<vector<int>>& grid) {
        vector<vector<char>> visited(rows, vector<char>(cols, 0));
        int count = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (grid[i][j] == 1 && !visited[i][j]) {
                    count++;
                    dfs(grid, visited, i, j);
                }
            }
        }
        return count;
    }
    void dfs(vector<vector<int>>& grid, vector<vector<char>>& visited, int i, int j) {
        if (i < 0 || i >= rows || j < 0 || j >= cols || grid[i][j] != 1 || visited[i][j]) return;
        visited[i][j] = 1;
        dfs(grid, visited, i+1, j);
        dfs(grid, visited, i-1, j);
        dfs(grid, visited, i, j+1);
        dfs(grid, visited, i, j-1);
    }
};
