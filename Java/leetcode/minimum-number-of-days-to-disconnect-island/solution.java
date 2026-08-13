class Solution {
    private int rows, cols;
    public int minDays(int[][] grid) {
        rows = grid.length;
        cols = grid[0].length;
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
    private int countIslands(int[][] grid) {
        boolean[][] visited = new boolean[rows][cols];
        int count = 0;
        for (int i = 0; i < rows; i++)
            for (int j = 0; j < cols; j++)
                if (grid[i][j] == 1 && !visited[i][j]) {
                    count++;
                    dfs(grid, visited, i, j);
                }
        return count;
    }
    private void dfs(int[][] grid, boolean[][] visited, int i, int j) {
        if (i < 0 || i >= rows || j < 0 || j >= cols || grid[i][j] != 1 || visited[i][j]) return;
        visited[i][j] = true;
        dfs(grid, visited, i+1, j);
        dfs(grid, visited, i-1, j);
        dfs(grid, visited, i, j+1);
        dfs(grid, visited, i, j-1);
    }
}
