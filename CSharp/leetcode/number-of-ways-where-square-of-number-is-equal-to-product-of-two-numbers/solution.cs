public class Solution {
    private long Helper(int[] a, int[] b) {
        long cnt = 0;
        foreach (int x in a) {
            long t = (long)x * x;
            var seen = new Dictionary<long, long>();
            foreach (int y in b) {
                if (t % y == 0) {
                    long need = t / y;
                    if (seen.TryGetValue(need, out long c)) cnt += c;
                }
                seen[y] = seen.TryGetValue(y, out long v) ? v + 1 : 1;
            }
        }
        return cnt;
    }
    public int NumTriplets(int[] nums1, int[] nums2) {
        return (int)(Helper(nums1, nums2) + Helper(nums2, nums1));
    }
}
