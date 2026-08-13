import java.util.*;
class Solution {
    private boolean backtrack(int[] nums, boolean[] used, int k, long cur, int start, long target) {
        if (k == 0) return true;
        if (cur == target) return backtrack(nums, used, k - 1, 0, 0, target);
        for (int i = start; i < nums.length; i++) {
            if (used[i] || cur + nums[i] > target) continue;
            used[i] = true;
            if (backtrack(nums, used, k, cur + nums[i], i + 1, target)) return true;
            used[i] = false;
            if (cur == 0) break;
        }
        return false;
    }
    public boolean canPartitionKSubsets(int[] nums, int k) {
        if (k <= 0 || nums.length < k) return false;
        long sum = 0;
        for (int x : nums) sum += x;
        if (sum % k != 0) return false;
        long target = sum / k;
        Arrays.sort(nums);
        for (int i = 0, j = nums.length - 1; i < j; i++, j--) {
            int t = nums[i]; nums[i] = nums[j]; nums[j] = t;
        }
        if (nums[0] > target) return false;
        boolean[] used = new boolean[nums.length];
        return backtrack(nums, used, k, 0, 0, target);
    }
}
