class Solution {
public:
    int countGoodRectangles(vector<vector<int>>& rectangles) {
        int maxLen = 0, count = 0;
        for (auto& r : rectangles) {
            int side = min(r[0], r[1]);
            if (side > maxLen) { maxLen = side; count = 1; }
            else if (side == maxLen) { count++; }
        }
        return count;
    }
};
