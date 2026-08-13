public class Solution {
    public int CountMaxOrSubsets(int[] nums) {
        int n = nums.Length;
        int maxOr = 0;
        foreach (int num in nums) {
            maxOr |= num;
        }

        int count = 0;
        for (int mask = 1; mask < (1 << n); mask++) {
            int currentOr = 0;
            for (int i = 0; i < n; i++) {
                if ((mask & (1 << i)) != 0) {
                    currentOr |= nums[i];
                }
            }
            if (currentOr == maxOr) {
                count++;
            }
        }
        return count;
    }
}