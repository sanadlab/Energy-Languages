#include <stdbool.h>
static void dfs(struct TreeNode* n, struct TreeNode* p, int d, int x, int y,
                int* dx, int* dy, struct TreeNode** px, struct TreeNode** py) {
    if (!n) return;
    if (n->val == x) { *dx = d; *px = p; }
    if (n->val == y) { *dy = d; *py = p; }
    dfs(n->left, n, d + 1, x, y, dx, dy, px, py);
    dfs(n->right, n, d + 1, x, y, dx, dy, px, py);
}
bool isCousins(struct TreeNode* root, int x, int y) {
    int dx = -1, dy = -1; struct TreeNode *px = NULL, *py = NULL;
    dfs(root, NULL, 0, x, y, &dx, &dy, &px, &py);
    return dx == dy && px != py;
}
