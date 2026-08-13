class Solution {
public:
    vector<int> sortByBits(vector<int>& arr) {
        sort(arr.begin(), arr.end(), [](int a, int b) {
            int pa = __builtin_popcount(a), pb = __builtin_popcount(b);
            if (pa != pb) return pa < pb;
            return a < b;
        });
        return arr;
    }
};
