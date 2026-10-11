class Solution {
public:
    bool isCousins(TreeNode* root, int x, int y) {
        if (!root) return false;

        std::queue<std::pair<TreeNode*, TreeNode*>> q;
        q.push({root, nullptr});

        while (!q.empty()) {
            int levelSize = q.size();
            bool foundX = false, foundY = false;
            TreeNode* parentX = nullptr;
            TreeNode* parentY = nullptr;

            for (int i = 0; i < levelSize; ++i) {
                auto [node, parent] = q.front();
                q.pop();

                if (node->val == x) {
                    foundX = true;
                    parentX = parent;
                }
                if (node->val == y) {
                    foundY = true;
                    parentY = parent;
                }

                if (node->left) q.push({node->left, node});
                if (node->right) q.push({node->right, node});
            }

            if (foundX || foundY) {
                return foundX && foundY && parentX != parentY;
            }
        }

        return false;
    }
};