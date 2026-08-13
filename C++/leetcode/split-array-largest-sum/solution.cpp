class Solution {
public:
    int splitArray(vector<int>& nums, int k) {
        long long lo = 0, hi = 0;
        for (int x : nums) { lo = max(lo, (long long)x); hi += x; }
        while (lo < hi) {
            long long mid = lo + (hi - lo) / 2;
            long long cnt = 1, cur = 0;
            for (int x : nums) {
                if (cur + x > mid) { cnt++; cur = x; }
                else cur += x;
            }
            if (cnt <= k) hi = mid;
            else lo = mid + 1;
        }
        return (int)lo;
    }
};
