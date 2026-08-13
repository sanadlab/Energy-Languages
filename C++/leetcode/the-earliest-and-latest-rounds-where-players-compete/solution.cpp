class Solution {
public:
    map<int, pair<int,int>> memo;
    pair<int,int> dp(int n, int f, int s) {
        if (f + s == n + 1) return {1, 1};
        if (f + s > n + 1) { int t = f; f = n + 1 - s; s = n + 1 - t; }
        int key = (n * 100 + f) * 100 + s;
        auto it = memo.find(key);
        if (it != memo.end()) return it->second;
        int half = (n + 1) / 2;
        const int INF = 1 << 30;
        int earliest = INF, latest = -INF;
        if (s <= half) {
            for (int i = 0; i < f; i++)
                for (int j = 0; j < s - f; j++) {
                    auto r = dp(half, i + 1, i + j + 2);
                    earliest = min(earliest, r.first);
                    latest = max(latest, r.second);
                }
        } else {
            int sp = n + 1 - s;
            int mid = n / 2;
            for (int i = 0; i < f; i++)
                for (int j = 0; j < sp - f; j++) {
                    auto r = dp(half, i + 1, i + (mid - sp) + j + 2);
                    earliest = min(earliest, r.first);
                    latest = max(latest, r.second);
                }
        }
        pair<int,int> res = {earliest + 1, latest + 1};
        memo[key] = res;
        return res;
    }
    vector<int> earliestAndLatest(int n, int firstPlayer, int secondPlayer) {
        if (firstPlayer == secondPlayer) return {1, 1};
        if (firstPlayer > secondPlayer) { int t = firstPlayer; firstPlayer = secondPlayer; secondPlayer = t; }
        auto r = dp(n, firstPlayer, secondPlayer);
        return {r.first, r.second};
    }
};
