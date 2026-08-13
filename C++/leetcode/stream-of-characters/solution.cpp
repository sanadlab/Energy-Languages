class Solution {
    struct Node {
        Node* next[26] = {};
        bool word = false;
    };
    Node* root = nullptr;
    string stream;
    int maxLen = 0;
public:
    bool StreamChecker(vector<string>& words) {
        root = new Node();
        maxLen = 0;
        stream = "";
        for (auto& w : words) {
            Node* node = root;
            for (int i = (int)w.size() - 1; i >= 0; i--) {
                int c = w[i] - 'a';
                if (!node->next[c]) node->next[c] = new Node();
                node = node->next[c];
            }
            node->word = true;
            if ((int)w.size() > maxLen) maxLen = w.size();
        }
        return true;
    }
    bool query(char letter) {
        stream.push_back(letter);
        Node* node = root;
        int n = stream.size();
        for (int step = 0; step < maxLen && step < n; step++) {
            int c = stream[n - 1 - step] - 'a';
            if (!node->next[c]) return false;
            node = node->next[c];
            if (node->word) return true;
        }
        return false;
    }
};
