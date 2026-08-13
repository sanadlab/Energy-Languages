public class Solution {
    private bool Backtrack(int[] nums, bool[] used, int k, long cur, int start, long target) {
        if (k == 0) return true;
        if (cur == target) return Backtrack(nums, used, k - 1, 0, 0, target);
        for (int i = start; i < nums.Length; i++) {
            if (used[i]) continue;
            if (cur + nums[i] > target) continue;
            used[i] = true;
            if (Backtrack(nums, used, k, cur + nums[i], i + 1, target)) return true;
            used[i] = false;
            if (cur == 0) break;
        }
        return false;
    }
    public bool CanPartitionKSubsets(int[] nums, int k) {
        if (k <= 0 || nums.Length < k) return false;
        long sum = 0;
        foreach (int x in nums) sum += x;
        if (sum % k != 0) return false;
        long target = sum / k;
        Array.Sort(nums);
        Array.Reverse(nums);
        if (nums[0] > target) return false;
        bool[] used = new bool[nums.Length];
        return Backtrack(nums, used, k, 0, 0, target);
    }
}
