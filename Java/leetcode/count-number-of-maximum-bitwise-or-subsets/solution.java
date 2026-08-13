class Solution {
    public int countMaxOrSubsets(int[] nums) {
        int maxOr = 0;
        for (int num : nums) {
            maxOr |= num; // Calculate the maximum possible OR value
        }

        int count = 0;
        int totalSubsets = 1 << nums.length; // Total number of subsets

        for (int i = 1; i < totalSubsets; i++) {
            int currentOr = 0;
            for (int j = 0; j < nums.length; j++) {
                if ((i & (1 << j)) != 0) {
                    currentOr |= nums[j];
                }
            }
            if (currentOr == maxOr) {
                count++;
            }
        }

        return count;
    }
}