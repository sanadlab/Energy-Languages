class Solution {
public:
    int maxPoints(vector<vector<int>>& points) {
        int n = points.size();
        if (n <= 2) return n;
        int best = 1;
        for (int i = 0; i < n; i++) {
            unordered_map<long long, int> slopes;
            for (int j = i + 1; j < n; j++) {
                int dx = points[j][0] - points[i][0];
                int dy = points[j][1] - points[i][1];
                int ax = dx < 0 ? -dx : dx;
                int ay = dy < 0 ? -dy : dy;
                int g = gcdi(ax, ay);
                dx /= g;
                dy /= g;
                if (dx < 0 || (dx == 0 && dy < 0)) { dx = -dx; dy = -dy; }
                long long key = (long long)dx * 1000000LL + dy;
                int c = ++slopes[key];
                if (c + 1 > best) best = c + 1;
            }
        }
        return best;
    }
private:
    int gcdi(int a, int b) {
        while (b) { int t = b; b = a % b; a = t; }
        return a;
    }
};
