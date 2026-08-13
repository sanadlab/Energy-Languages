import java.util.ArrayList;
import java.util.List;

class Solution {
    public List<Integer> findKDistantIndices(int[] nums, int key, int k) {
        int n = nums.length;
        boolean[] mark = new boolean[n];
        for (int j = 0; j < n; j++) {
            if (nums[j] == key) {
                int lo = Math.max(0, j - k);
                int hi = Math.min(n - 1, j + k);
                for (int i = lo; i <= hi; i++) {
                    mark[i] = true;
                }
            }
        }
        List<Integer> result = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            if (mark[i]) {
                result.add(i);
            }
        }
        return result;
    }
}
