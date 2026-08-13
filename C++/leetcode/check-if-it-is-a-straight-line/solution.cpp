class Solution {
public:
    bool checkStraightLine(vector<vector<int>>& coordinates) {
        int n = coordinates.size();
        if (n == 2) {
            return true;
        }

        int x0 = coordinates[0][0], y0 = coordinates[0][1];
        int x1 = coordinates[1][0], y1 = coordinates[1][1];

        for (int i = 2; i < n; i++) {
            int x = coordinates[i][0], y = coordinates[i][1];
            long long cross = (long long)(x1 - x0) * (y - y0) - (long long)(y1 - y0) * (x - x0);
            if (cross != 0) {
                return false;
            }
        }
        return true;
    }
};