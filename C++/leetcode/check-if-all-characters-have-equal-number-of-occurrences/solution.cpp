class Solution {
public:
    bool areOccurrencesEqual(string s) {
        unordered_map<char, int> cnt;
        for (char c : s) cnt[c]++;
        int f = -1;
        for (auto& p : cnt) {
            if (f == -1) f = p.second;
            else if (p.second != f) return false;
        }
        return true;
    }
};
