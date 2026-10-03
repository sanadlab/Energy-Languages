#include <stdlib.h>

static int countIslands(int** grid, int rows, int cols, int* visited, int* stackX, int* stackY) {
    for (int i = 0; i < rows * cols; i++) visited[i] = 0;
    static const int dx[4] = {1, -1, 0, 0};
    static const int dy[4] = {0, 0, 1, -1};
    int count = 0;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            if (grid[i][j] == 1 && !visited[i * cols + j]) {
                count++;
                int sp = 0;
                stackX[sp] = i; stackY[sp] = j; sp++;
                visited[i * cols + j] = 1;
                while (sp > 0) {
                    sp--;
                    int x = stackX[sp], y = stackY[sp];
                    for (int d = 0; d < 4; d++) {
                        int nx = x + dx[d], ny = y + dy[d];
                        if (nx >= 0 && nx < rows && ny >= 0 && ny < cols &&
                            grid[nx][ny] == 1 && !visited[nx * cols + ny]) {
                            visited[nx * cols + ny] = 1;
                            stackX[sp] = nx; stackY[sp] = ny; sp++;
                        }
                    }
                }
            }
        }
    }
    return count;
}

int minDays(int** grid, int gridSize, int* gridColSize) {
    int rows = gridSize, cols = gridColSize[0];
    int* visited = (int*)malloc(rows * cols * sizeof(int));
    int* stackX = (int*)malloc(rows * cols * sizeof(int));
    int* stackY = (int*)malloc(rows * cols * sizeof(int));
    int result;
    if (countIslands(grid, rows, cols, visited, stackX, stackY) != 1) {
        result = 0;
    } else {
        result = 2;
        for (int i = 0; i < rows && result == 2; i++) {
            for (int j = 0; j < cols; j++) {
                if (grid[i][j] == 1) {
                    grid[i][j] = 0;
                    if (countIslands(grid, rows, cols, visited, stackX, stackY) != 1) {
                        grid[i][j] = 1;
                        result = 1;
                        break;
                    }
                    grid[i][j] = 1;
                }
            }
        }
    }
    free(visited); free(stackX); free(stackY);
    return result;
}
