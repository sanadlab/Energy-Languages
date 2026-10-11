public class Solution {
    private int[] nums;
    private Random rand;

    public Solution(int[] nums) {
        this.nums = nums;
        this.rand = new Random();
    }
    
    public int Pick(int target) {
        int count = 0;
        int result = -1;
        for (int i = 0; i < nums.Length; i++) {
            if (nums[i] == target) {
                count++;
                if (rand.Next(count) == 0) {
                    result = i;
                }
            }
        }
        return result;
    }
}

/**
 * Your Solution object will be instantiated and called as such:
 * Solution obj = new Solution(nums);
 * int param_1 = obj.Pick(target);
 */