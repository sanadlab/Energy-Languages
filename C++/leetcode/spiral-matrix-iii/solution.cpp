class Solution {
public:
    vector<vector<int>> spiralMatrixIII(int rows, int cols, int rStart, int cStart) {
        int total = rows * cols;
        vector<vector<int>> res;
        int r = rStart, c = cStart;
        if (r >= 0 && r < rows && c >= 0 && c < cols) res.push_back({r, c});
        int dr[] = {0, 1, 0, -1};
        int dc[] = {1, 0, -1, 0};
        int step = 1, d = 0;
        while ((int)res.size() < total) {
            for (int t = 0; t < 2; t++) {
                for (int s = 0; s < step; s++) {
                    r += dr[d % 4];
                    c += dc[d % 4];
                    if (r >= 0 && r < rows && c >= 0 && c < cols) res.push_back({r, c});
                }
                d++;
            }
            step++;
        }
        return res;
    }
};
