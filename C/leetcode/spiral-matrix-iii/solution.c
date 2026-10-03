#include <stdlib.h>

/**
 * Return an array of arrays of size *returnSize.
 * The sizes of the arrays are returned as *returnColumnSizes array.
 * Note: Both returned array and *columnSizes array must be malloced, assume caller calls free().
 */
int** spiralMatrixIII(int rows, int cols, int rStart, int cStart, int* returnSize, int** returnColumnSizes) {
    int total = rows * cols;
    int** res = (int**) malloc(sizeof(int*) * total);
    int* colSizes = (int*) malloc(sizeof(int) * total);
    int dr[4] = {0, 1, 0, -1};
    int dc[4] = {1, 0, -1, 0};
    int idx = 0;
    int r = rStart, c = cStart;
    if (r >= 0 && r < rows && c >= 0 && c < cols) {
        res[idx] = (int*) malloc(sizeof(int) * 2);
        res[idx][0] = r; res[idx][1] = c;
        colSizes[idx] = 2;
        idx++;
    }
    int step = 1, d = 0;
    while (idx < total) {
        for (int rep = 0; rep < 2; rep++) {
            for (int s = 0; s < step; s++) {
                r += dr[d % 4];
                c += dc[d % 4];
                if (r >= 0 && r < rows && c >= 0 && c < cols) {
                    res[idx] = (int*) malloc(sizeof(int) * 2);
                    res[idx][0] = r; res[idx][1] = c;
                    colSizes[idx] = 2;
                    idx++;
                }
            }
            d++;
        }
        step++;
    }
    *returnSize = idx;
    *returnColumnSizes = colSizes;
    return res;
}
