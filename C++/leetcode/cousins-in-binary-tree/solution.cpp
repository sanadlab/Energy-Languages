struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *l, TreeNode *r) : val(x), left(l), right(r) {}
};

class Solution {
public:
    bool isCousins(TreeNode* root, int x, int y) {
        int dx = -1, dy = -1;
        TreeNode *px = nullptr, *py = nullptr;
        function<void(TreeNode*, TreeNode*, int)> dfs =
            [&](TreeNode* node, TreeNode* parent, int depth) {
                if (!node) return;
                if (node->val == x) { dx = depth; px = parent; }
                if (node->val == y) { dy = depth; py = parent; }
                dfs(node->left, node, depth + 1);
                dfs(node->right, node, depth + 1);
            };
        dfs(root, nullptr, 0);
        return dx == dy && px != py;
    }
};
