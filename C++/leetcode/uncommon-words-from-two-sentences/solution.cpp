class Solution {
public:
    vector<string> uncommonFromSentences(string s1, string s2) {
        unordered_map<string,int> cnt;
        auto add = [&](const string& str){
            string cur;
            for (char c : str) {
                if (c == ' ') { if (!cur.empty()) { cnt[cur]++; cur.clear(); } }
                else cur += c;
            }
            if (!cur.empty()) cnt[cur]++;
        };
        add(s1); add(s2);
        vector<string> res;
        for (auto& p : cnt) if (p.second == 1) res.push_back(p.first);
        return res;
    }
};
