class Solution {
public:
    // Exact recursion over the positions of the two players: each round, every
    // other match may go either way, so enumerate how many winners finish ahead
    // of each player (only those counts matter for the next round).
    map<int, pair<int, int>> memo;
    pair<int, int> dp(int m, int f, int s) {
        if (f > s) swap(f, s);
        if (f + s == m + 1) return {1, 1};
        int key = m * 10000 + f * 100 + s;
        auto it = memo.find(key);
        if (it != memo.end()) return it->second;
        set<int> states = {0};                       // bf * 100 + bs
        auto step = [&](const vector<int>& opts) {
            set<int> next;
            for (int st : states) {
                int bf = st / 100, bs = st % 100;
                for (int w : opts) next.insert((bf + (w < f)) * 100 + (bs + (w < s)));
            }
            states.swap(next);
        };
        for (int p = 1; p <= m / 2; p++) {
            int q = m + 1 - p;
            if (p == f || q == f) step({f});
            else if (p == s || q == s) step({s});
            else step({p, q});
        }
        if (m % 2 == 1) step({(m + 1) / 2});
        int earliest = INT_MAX, latest = INT_MIN;
        for (int st : states) {
            auto r = dp((m + 1) / 2, st / 100 + 1, st % 100 + 1);
            earliest = min(earliest, r.first + 1);
            latest = max(latest, r.second + 1);
        }
        return memo[key] = {earliest, latest};
    }
    vector<int> earliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        auto r = dp(n, firstPlayer, secondPlayer);
        return {r.first, r.second};
    }
};
