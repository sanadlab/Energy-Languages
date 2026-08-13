public class Solution {
    public long MaxRunTime(int n, int[] batteries) {
        long sum = 0;
        foreach (int b in batteries) sum += b;
        long lo = 0, hi = sum / n;
        while (lo < hi) {
            long mid = (lo + hi + 1) / 2;
            long avail = 0;
            foreach (int b in batteries) avail += Math.Min((long)b, mid);
            if (avail >= (long)n * mid) lo = mid; else hi = mid - 1;
        }
        return lo;
    }
}
