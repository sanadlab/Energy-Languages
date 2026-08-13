class Solution {
public:
    int minAreaRect(vector<vector<int>>& points) {
        unordered_set<long long> seen;
        int n = points.size();
        for (auto& p : points) seen.insert((long long)p[0] * 50000LL + p[1]);
        long long best = LLONG_MAX;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int x1 = points[i][0], y1 = points[i][1];
                int x2 = points[j][0], y2 = points[j][1];
                if (x1 != x2 && y1 != y2) {
                    if (seen.count((long long)x1 * 50000LL + y2) &&
                        seen.count((long long)x2 * 50000LL + y1)) {
                        long long area = (long long)abs(x1 - x2) * abs(y1 - y2);
                        best = min(best, area);
                    }
                }
            }
        }
        return best == LLONG_MAX ? 0 : (int)best;
    }
};
