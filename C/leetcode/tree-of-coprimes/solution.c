#include <stdlib.h>

static int g_gcd(int a, int b) {
    while (b) { int t = a % b; a = b; b = t; }
    return a;
}

static int *gc_nums, *gc_adj, *gc_off, *gc_ans;
static int *gc_ds[51], *gc_ns[51], gc_cnt[51];
static int gc_coprime[51][51], gc_copn[51];

static void gc_dfs(int node, int parent, int depth) {
    int val = gc_nums[node];
    int best_depth = -1, best_node = -1;
    for (int i = 0; i < gc_copn[val]; i++) {
        int cv = gc_coprime[val][i];
        if (gc_cnt[cv] > 0) {
            int d = gc_ds[cv][gc_cnt[cv] - 1];
            if (d > best_depth) {
                best_depth = d;
                best_node = gc_ns[cv][gc_cnt[cv] - 1];
            }
        }
    }
    gc_ans[node] = best_node;

    gc_ds[val][gc_cnt[val]] = depth;
    gc_ns[val][gc_cnt[val]] = node;
    gc_cnt[val]++;

    for (int e = gc_off[node]; e < gc_off[node + 1]; e++) {
        int nb = gc_adj[e];
        if (nb != parent) gc_dfs(nb, node, depth + 1);
    }

    gc_cnt[val]--;
}

/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* getCoprimes(int* nums, int numsSize, int** edges, int edgesSize, int* edgesColSize, int* returnSize) {
    int n = numsSize;
    int* ans = (int*) malloc(sizeof(int) * (n > 0 ? n : 1));
    for (int i = 0; i < n; i++) ans[i] = -1;
    *returnSize = n;
    if (n == 0) return ans;

    // build CSR adjacency
    int* deg = (int*) calloc(n, sizeof(int));
    for (int i = 0; i < edgesSize; i++) {
        int u = edges[i][0], v = edges[i][1];
        if (u >= 0 && u < n && v >= 0 && v < n) { deg[u]++; deg[v]++; }
    }
    int* off = (int*) malloc(sizeof(int) * (n + 1));
    off[0] = 0;
    for (int i = 0; i < n; i++) off[i + 1] = off[i] + deg[i];
    int total = off[n];
    int* adj = (int*) malloc(sizeof(int) * (total > 0 ? total : 1));
    int* pos = (int*) malloc(sizeof(int) * n);
    for (int i = 0; i < n; i++) pos[i] = off[i];
    for (int i = 0; i < edgesSize; i++) {
        int u = edges[i][0], v = edges[i][1];
        if (u >= 0 && u < n && v >= 0 && v < n) { adj[pos[u]++] = v; adj[pos[v]++] = u; }
    }

    // coprime lists for values 1..50
    for (int a = 1; a <= 50; a++) {
        gc_copn[a] = 0;
        for (int b = 1; b <= 50; b++)
            if (g_gcd(a, b) == 1) gc_coprime[a][gc_copn[a]++] = b;
    }

    // ancestor stacks indexed by value
    for (int v = 1; v <= 50; v++) {
        gc_ds[v] = (int*) malloc(sizeof(int) * n);
        gc_ns[v] = (int*) malloc(sizeof(int) * n);
        gc_cnt[v] = 0;
    }

    gc_nums = nums; gc_adj = adj; gc_off = off; gc_ans = ans;
    gc_dfs(0, -1, 0);

    for (int v = 1; v <= 50; v++) { free(gc_ds[v]); free(gc_ns[v]); }
    free(deg); free(off); free(adj); free(pos);
    return ans;
}
