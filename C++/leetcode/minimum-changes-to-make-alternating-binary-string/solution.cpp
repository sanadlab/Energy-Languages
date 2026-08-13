class Solution {
public:
    int minOperations(string s) {
        int cnt = 0, n = s.size();
        for (int i = 0; i < n; ++i) {
            char expected = (i % 2 == 0) ? '0' : '1';
            if (s[i] != expected) ++cnt;
        }
        return min(cnt, n - cnt);
    }
};
