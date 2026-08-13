public class Solution {
    public int MinDays(int[] bloomDay, int m, int k) {
        long need = (long)m * k;
        if (need > bloomDay.Length) return -1;
        int lo = int.MaxValue, hi = int.MinValue;
        foreach (int b in bloomDay) { if (b < lo) lo = b; if (b > hi) hi = b; }
        while (lo < hi) {
            int mid = lo + (hi - lo) / 2;
            if (CanMake(bloomDay, m, k, mid)) hi = mid;
            else lo = mid + 1;
        }
        return lo;
    }
    private bool CanMake(int[] bloomDay, int m, int k, int day) {
        int bouquets = 0, flowers = 0;
        foreach (int b in bloomDay) {
            if (b <= day) {
                flowers++;
                if (flowers == k) { bouquets++; flowers = 0; }
            } else {
                flowers = 0;
            }
        }
        return bouquets >= m;
    }
}
