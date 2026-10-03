#include <stdlib.h>
#include <stdbool.h>

static int uf_find(int* parent, int x) {
    while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
    }
    return x;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
bool* friendRequests(int n, int** restrictions, int restrictionsSize, int* restrictionsColSize, int** requests, int requestsSize, int* requestsColSize, int* returnSize) {
    int* parent = (int*) malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) parent[i] = i;
    bool* res = (bool*) malloc(sizeof(bool) * (requestsSize > 0 ? requestsSize : 1));
    for (int r = 0; r < requestsSize; r++) {
        int u = requests[r][0], v = requests[r][1];
        int pu = uf_find(parent, u), pv = uf_find(parent, v);
        if (pu == pv) { res[r] = true; continue; }
        bool ok = true;
        for (int i = 0; i < restrictionsSize; i++) {
            int px = uf_find(parent, restrictions[i][0]);
            int py = uf_find(parent, restrictions[i][1]);
            if ((px == pu && py == pv) || (px == pv && py == pu)) { ok = false; break; }
        }
        if (ok) { parent[pu] = pv; res[r] = true; }
        else res[r] = false;
    }
    free(parent);
    *returnSize = requestsSize;
    return res;
}
