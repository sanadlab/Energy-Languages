#include <stdlib.h>
#include <stdbool.h>

bool validateBinaryTreeNodes(int n, int* leftChild, int leftChildSize, int* rightChild, int rightChildSize) {
    int m = leftChildSize < rightChildSize ? leftChildSize : rightChildSize;
    int* indeg = calloc(n, sizeof(int));
    for (int i = 0; i < m; i++) {
        int children[2] = {leftChild[i], rightChild[i]};
        for (int k = 0; k < 2; k++) {
            int c = children[k];
            if (c != -1) {
                if (c < 0 || c >= n) { free(indeg); return false; }
                indeg[c]++;
                if (indeg[c] > 1) { free(indeg); return false; }
            }
        }
    }

    int root = -1;
    for (int i = 0; i < n; i++) {
        if (indeg[i] == 0) {
            if (root != -1) { free(indeg); return false; }
            root = i;
        }
    }
    if (root == -1) { free(indeg); return false; }

    bool* visited = calloc(n, sizeof(bool));
    int* stack = malloc((size_t)(n + 1) * sizeof(int));
    int top = 0;
    stack[top++] = root;
    int count = 0;
    while (top > 0) {
        int node = stack[--top];
        if (visited[node]) { free(indeg); free(visited); free(stack); return false; }
        visited[node] = true;
        count++;
        if (node < m) {
            int children[2] = {leftChild[node], rightChild[node]};
            for (int k = 0; k < 2; k++) {
                int c = children[k];
                if (c != -1) stack[top++] = c;
            }
        }
    }

    free(indeg); free(visited); free(stack);
    return count == n;
}
