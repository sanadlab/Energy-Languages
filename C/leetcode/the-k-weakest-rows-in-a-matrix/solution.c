#include <stdlib.h>

typedef struct { int cnt, idx; } Row;

static int cmp_row(const void* a, const void* b) {
    const Row* x = (const Row*)a;
    const Row* y = (const Row*)b;
    if (x->cnt != y->cnt) return x->cnt - y->cnt;
    return x->idx - y->idx;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* kWeakestRows(int** mat, int matSize, int* matColSize, int k, int* returnSize) {
    Row* rows = (Row*) malloc(sizeof(Row) * (matSize > 0 ? matSize : 1));
    for (int i = 0; i < matSize; i++) {
        int c = 0;
        for (int j = 0; j < matColSize[i]; j++) c += mat[i][j];
        rows[i].cnt = c;
        rows[i].idx = i;
    }
    qsort(rows, matSize, sizeof(Row), cmp_row);
    int* res = (int*) malloc(sizeof(int) * (k > 0 ? k : 1));
    for (int i = 0; i < k; i++) res[i] = rows[i].idx;
    free(rows);
    *returnSize = k;
    return res;
}
