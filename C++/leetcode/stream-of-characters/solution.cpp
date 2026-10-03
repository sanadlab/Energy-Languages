#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>
using namespace std;

class StreamChecker {
public:
    struct Node {
        unordered_map<char, Node*> children;
        bool end = false;
    };
    Node* root;
    string buf;
    int maxLen = 0;

    StreamChecker(vector<string>& words) {
        root = new Node();
        for (auto& w : words) {
            Node* node = root;
            for (int i = (int)w.size() - 1; i >= 0; i--) {
                char ch = w[i];
                if (!node->children.count(ch)) node->children[ch] = new Node();
                node = node->children[ch];
            }
            node->end = true;
            if ((int)w.size() > maxLen) maxLen = (int)w.size();
        }
    }

    bool query(char letter) {
        buf.push_back(letter);
        Node* node = root;
        int n = (int)buf.size();
        int steps = min(maxLen, n);
        for (int s = 0; s < steps; s++) {
            char ch = buf[n - 1 - s];
            auto it = node->children.find(ch);
            if (it == node->children.end()) return false;
            node = it->second;
            if (node->end) return true;
        }
        return false;
    }
};
