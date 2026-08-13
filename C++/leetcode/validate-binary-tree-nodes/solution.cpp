class Solution {
public:
    bool validateBinaryTreeNodes(int n, vector<int>& leftChild, vector<int>& rightChild) {
        vector<int> parent(n, -1);
        
        for (int i = 0; i < n; i++) {
            int left = leftChild[i];
            if (left != -1) {
                if (parent[left] != -1) {
                    return false;
                }
                parent[left] = i;
            }
            
            int right = rightChild[i];
            if (right != -1) {
                if (parent[right] != -1) {
                    return false;
                }
                parent[right] = i;
            }
        }
        
        int roots = 0;
        for (int i = 0; i < n; i++) {
            if (parent[i] == -1) {
                roots++;
            }
        }
        
        return roots == 1;
    }
};