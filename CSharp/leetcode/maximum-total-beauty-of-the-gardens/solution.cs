public class Solution {
    private int LowerBound(int[] a, int hiIdx, int v) {
        int lo = 0, hi = hiIdx;
        while (lo < hi) {
            int mid = (lo + hi) / 2;
            if (a[mid] < v) lo = mid + 1; else hi = mid;
        }
        return lo;
    }
    public long MaximumBeauty(int[] flowers, long newFlowers, int target, int full, int partial) {
        int n = flowers.Length;
        if (n == 0) return 0;
        int[] fl = new int[n];
        for (int i = 0; i < n; i++) fl[i] = Math.Min(flowers[i], target);
        Array.Sort(fl);
        long[] pre = new long[n + 1];
        for (int i = 0; i < n; i++) pre[i + 1] = pre[i] + fl[i];
        if (fl[0] == target) return (long)full * n;
        long ans = 0;
        for (int i = n; i >= 0; i--) {
            long costComplete = (long)target * (n - i) - (pre[n] - pre[i]);
            if (costComplete > newFlowers) continue;
            long rem = newFlowers - costComplete;
            if (i == 0) { ans = Math.Max(ans, (long)full * (n - i)); continue; }
            int lo = 0, hi = target - 1, bestMin = 0;
            while (lo <= hi) {
                int v = lo + (hi - lo) / 2;
                int k = LowerBound(fl, i, v);
                long cost = (long)v * k - pre[k];
                if (cost <= rem) { bestMin = v; lo = v + 1; } else { hi = v - 1; }
            }
            ans = Math.Max(ans, (long)full * (n - i) + (long)bestMin * partial);
        }
        return ans;
    }
}
