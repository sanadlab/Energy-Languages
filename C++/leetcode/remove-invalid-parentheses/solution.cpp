class Solution {
public:
    bool valid(const string& st) {
        int cnt = 0;
        for (char ch : st) {
            if (ch == '(') cnt++;
            else if (ch == ')') { cnt--; if (cnt < 0) return false; }
        }
        return cnt == 0;
    }
    vector<string> removeInvalidParentheses(string s) {
        unordered_set<string> level{s};
        while (!level.empty()) {
            vector<string> valids;
            for (const auto& st : level) if (valid(st)) valids.push_back(st);
            if (!valids.empty()) return valids;
            unordered_set<string> nxt;
            for (const auto& st : level) {
                for (int i = 0; i < (int)st.size(); i++) {
                    if (st[i] == '(' || st[i] == ')') {
                        nxt.insert(st.substr(0, i) + st.substr(i + 1));
                    }
                }
            }
            level = nxt;
        }
        return {""};
    }
};
