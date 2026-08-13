import java.util.*;
class Solution {
    private long helper(int[] a, int[] b) {
        long cnt = 0;
        for (int x : a) {
            long t = (long) x * x;
            HashMap<Long, Long> seen = new HashMap<>();
            for (int y : b) {
                long yy = y;
                if (t % yy == 0) {
                    long need = t / yy;
                    cnt += seen.getOrDefault(need, 0L);
                }
                seen.merge(yy, 1L, Long::sum);
            }
        }
        return cnt;
    }
    public int numTriplets(int[] nums1, int[] nums2) {
        return (int)(helper(nums1, nums2) + helper(nums2, nums1));
    }
}
