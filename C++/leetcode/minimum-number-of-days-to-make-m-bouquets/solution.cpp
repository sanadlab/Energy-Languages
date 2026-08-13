class Solution {
public:
    int minDays(vector<int>& bloomDay, int m, int k) {
        long long need = (long long)m * k;
        if (need > (long long)bloomDay.size()) return -1;
        int lo = bloomDay[0], hi = bloomDay[0];
        for (int b : bloomDay) { lo = min(lo, b); hi = max(hi, b); }
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            if (canMake(bloomDay, m, k, mid)) hi = mid;
            else lo = mid + 1;
        }
        return lo;
    }
    bool canMake(vector<int>& bloomDay, int m, int k, int day) {
        int bouquets = 0, flowers = 0;
        for (int b : bloomDay) {
            if (b <= day) {
                flowers++;
                if (flowers == k) { bouquets++; flowers = 0; }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    }
};
