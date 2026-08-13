public class Solution {
    private int rows, cols;
    public int MinDays(int[][] grid) {
        rows = grid.Length;
        cols = grid[0].Length;
        if (CountIslands(grid) != 1) return 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (grid[i][j] == 1) {
                    grid[i][j] = 0;
                    if (CountIslands(grid) != 1) { grid[i][j] = 1; return 1; }
                    grid[i][j] = 1;
                }
            }
        }
        return 2;
    }
    private int CountIslands(int[][] grid) {
        bool[,] visited = new bool[rows, cols];
        int count = 0;
        for (int i = 0; i < rows; i++)
            for (int j = 0; j < cols; j++)
                if (grid[i][j] == 1 && !visited[i, j]) {
                    count++;
                    Dfs(grid, visited, i, j);
                }
        return count;
    }
    private void Dfs(int[][] grid, bool[,] visited, int i, int j) {
        if (i < 0 || i >= rows || j < 0 || j >= cols || grid[i][j] != 1 || visited[i, j]) return;
        visited[i, j] = true;
        Dfs(grid, visited, i+1, j);
        Dfs(grid, visited, i-1, j);
        Dfs(grid, visited, i, j+1);
        Dfs(grid, visited, i, j-1);
    }
}
