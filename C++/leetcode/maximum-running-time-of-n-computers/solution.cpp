class Solution {
public:
    long long maxRunTime(int n, vector<int>& batteries) {
        long long sum = 0;
        for (int b : batteries) sum += b;
        long long lo = 0, hi = sum / n;
        while (lo < hi) {
            long long mid = (lo + hi + 1) / 2;
            long long avail = 0;
            for (int b : batteries) avail += min((long long)b, mid);
            if (avail >= (long long)n * mid) lo = mid; else hi = mid - 1;
        }
        return lo;
    }
};
