#include <stdlib.h>

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* restoreArray(int** adjacentPairs, int adjacentPairsSize, int* adjacentPairsColSize, int* returnSize) {
    if (adjacentPairsSize == 0) {
        *returnSize = 0;
        return (int*) malloc(sizeof(int));
    }
    int n = adjacentPairsSize + 1;
    const int OFF = 100000, SZ = 200001;
    int* deg = (int*) calloc(SZ, sizeof(int));
    int* nb0 = (int*) malloc(sizeof(int) * SZ);
    int* nb1 = (int*) malloc(sizeof(int) * SZ);
    for (int i = 0; i < adjacentPairsSize; i++) {
        int u = adjacentPairs[i][0] + OFF, v = adjacentPairs[i][1] + OFF;
        if (deg[u] == 0) nb0[u] = v; else nb1[u] = v;
        deg[u]++;
        if (deg[v] == 0) nb0[v] = u; else nb1[v] = u;
        deg[v]++;
    }
    int start = adjacentPairs[0][0] + OFF;
    for (int i = 0; i < adjacentPairsSize; i++) {
        int u = adjacentPairs[i][0] + OFF, v = adjacentPairs[i][1] + OFF;
        if (deg[u] == 1) { start = u; break; }
        if (deg[v] == 1) { start = v; break; }
    }
    int* res = (int*) malloc(sizeof(int) * n);
    int cur = start, prev = -1, cnt = 0;
    res[cnt++] = cur - OFF;
    while (cnt < n) {
        int nxt = (nb0[cur] != prev) ? nb0[cur] : nb1[cur];
        res[cnt++] = nxt - OFF;
        prev = cur;
        cur = nxt;
    }
    free(deg); free(nb0); free(nb1);
    *returnSize = n;
    return res;
}
