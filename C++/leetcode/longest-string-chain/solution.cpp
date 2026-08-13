class Solution {
public:
    int longestStrChain(vector<string>& words) {
        sort(words.begin(), words.end(), [](const string& a, const string& b) {
            return a.size() < b.size();
        });
        unordered_map<string, int> dp;
        int best = 1;
        for (const string& w : words) {
            int cur = 1;
            for (int i = 0; i < (int)w.size(); i++) {
                string pred = w.substr(0, i) + w.substr(i + 1);
                auto it = dp.find(pred);
                if (it != dp.end()) cur = max(cur, it->second + 1);
            }
            dp[w] = cur;
            best = max(best, cur);
        }
        return best;
    }
};
