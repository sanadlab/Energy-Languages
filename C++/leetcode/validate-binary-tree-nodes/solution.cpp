class Solution {
public:
    bool validateBinaryTreeNodes(int n, vector<int>& leftChild, vector<int>& rightChild) {
        vector<int> parent(n, -1);
        for (int i = 0; i < n; i++) {
            for (int c : {leftChild[i], rightChild[i]}) {
                if (c == -1) continue;
                if (parent[c] != -1) return false;   // two parents
                parent[c] = i;
            }
        }
        int root = -1;
        for (int i = 0; i < n; i++) {
            if (parent[i] == -1) {
                if (root != -1) return false;         // two roots
                root = i;
            }
        }
        if (root == -1) return false;                 // every node has a parent: a cycle
        // One root is not enough: a cycle elsewhere leaves nodes unreachable.
        int seen = 0;
        vector<int> stack = {root};
        while (!stack.empty()) {
            int u = stack.back(); stack.pop_back();
            seen++;
            if (leftChild[u] != -1) stack.push_back(leftChild[u]);
            if (rightChild[u] != -1) stack.push_back(rightChild[u]);
        }
        return seen == n;
    }
};
