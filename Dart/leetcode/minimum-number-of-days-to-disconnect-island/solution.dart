class Solution {
  int minDays(List<List<int>> grid) {
    int rows = grid.length, cols = grid[0].length;

    int countIslands() {
      List<List<bool>> visited =
          List.generate(rows, (_) => List<bool>.filled(cols, false));
      int count = 0;
      const dirs = [
        [1, 0],
        [-1, 0],
        [0, 1],
        [0, -1]
      ];
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          if (grid[i][j] == 1 && !visited[i][j]) {
            count++;
            List<List<int>> stack = [
              [i, j]
            ];
            visited[i][j] = true;
            while (stack.isNotEmpty) {
              List<int> top = stack.removeLast();
              int x = top[0], y = top[1];
              for (var d in dirs) {
                int nx = x + d[0], ny = y + d[1];
                if (nx >= 0 &&
                    nx < rows &&
                    ny >= 0 &&
                    ny < cols &&
                    grid[nx][ny] == 1 &&
                    !visited[nx][ny]) {
                  visited[nx][ny] = true;
                  stack.add([nx, ny]);
                }
              }
            }
          }
        }
      }
      return count;
    }

    if (countIslands() != 1) return 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (grid[i][j] == 1) {
          grid[i][j] = 0;
          if (countIslands() != 1) {
            grid[i][j] = 1;
            return 1;
          }
          grid[i][j] = 1;
        }
      }
    }
    return 2;
  }
}
