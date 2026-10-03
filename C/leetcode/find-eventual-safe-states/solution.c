/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
/* color: 0 unvisited, 1 visiting/known-unsafe, 2 safe */
static bool dfs_safe(int** graph, int* colSize, int u, int* color) {
    if (color[u] > 0) return color[u] == 2;
    color[u] = 1;
    for (int i = 0; i < colSize[u]; i++) {
        int v = graph[u][i];
        if (color[v] == 2) continue;
        if (color[v] == 1 || !dfs_safe(graph, colSize, v, color))
            return false;
    }
    color[u] = 2;
    return true;
}

int* eventualSafeNodes(int** graph, int graphSize, int* graphColSize, int* returnSize) {
    int* color = (int*) calloc(graphSize > 0 ? graphSize : 1, sizeof(int));
    int* res = (int*) malloc(sizeof(int) * (graphSize > 0 ? graphSize : 1));
    int cnt = 0;
    for (int i = 0; i < graphSize; i++)
        if (dfs_safe(graph, graphColSize, i, color)) res[cnt++] = i;
    free(color);
    *returnSize = cnt;
    return res;
}
