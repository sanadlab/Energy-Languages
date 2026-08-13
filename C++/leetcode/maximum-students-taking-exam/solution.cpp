class Solution {
public:
    int maxStudents(vector<vector<char>>& seats) {
        int m = seats.size();
        if (m == 0) return 0;
        int n = seats[0].size();
        vector<int> avail(m, 0);
        for (int i = 0; i < m; i++)
            for (int j = 0; j < n && j < (int)seats[i].size(); j++)
                if (seats[i][j] == '.') avail[i] |= (1 << j);
        int full = 1 << n;
        vector<int> best(full, -1);
        best[0] = 0;
        for (int i = 0; i < m; i++) {
            vector<int> ndp(full, -1);
            for (int mask = 0; mask < full; mask++) {
                if ((mask & avail[i]) != mask) continue;
                if (mask & (mask << 1)) continue;
                int pc = __builtin_popcount(mask);
                for (int pmask = 0; pmask < full; pmask++) {
                    if (best[pmask] < 0) continue;
                    if (mask & (pmask << 1)) continue;
                    if (mask & (pmask >> 1)) continue;
                    int val = best[pmask] + pc;
                    if (val > ndp[mask]) ndp[mask] = val;
                }
            }
            best = ndp;
        }
        int ans = 0;
        for (int v : best) ans = max(ans, v);
        return ans;
    }
};
