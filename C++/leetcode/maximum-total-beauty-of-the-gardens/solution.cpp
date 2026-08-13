class Solution {
public:
    long long maximumBeauty(vector<int>& flowers, long long newFlowers, int target, int full, int partial) {
        int n = flowers.size();
        if (n == 0) return 0;
        vector<int> fl(n);
        for (int i = 0; i < n; i++) fl[i] = min(flowers[i], target);
        sort(fl.begin(), fl.end());
        vector<long long> pre(n + 1, 0);
        for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + fl[i];
        if (fl[0] == target) return (long long)full * n;
        long long ans = 0;
        for (int i = n; i >= 0; i--) {
            long long costComplete = (long long)target * (n - i) - (pre[n] - pre[i]);
            if (costComplete > newFlowers) continue;
            long long rem = newFlowers - costComplete;
            if (i == 0) { ans = max(ans, (long long)full * (n - i)); continue; }
            int lo = 0, hi = target - 1, bestMin = 0;
            while (lo <= hi) {
                int v = lo + (hi - lo) / 2;
                int k = lower_bound(fl.begin(), fl.begin() + i, v) - fl.begin();
                long long cost = (long long)v * k - pre[k];
                if (cost <= rem) { bestMin = v; lo = v + 1; } else { hi = v - 1; }
            }
            ans = max(ans, (long long)full * (n - i) + (long long)bestMin * partial);
        }
        return ans;
    }
};
