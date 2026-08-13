public class Solution {
    private int[] nums;
    private Random rng = new Random();

    public Solution() {
        this.nums = new int[0];
    }

    public Solution(int[] nums) {
        this.nums = nums;
    }

    public int Pick(int target) {
        if (nums == null) return -1;
        int count = 0;
        int res = -1;
        for (int i = 0; i < nums.Length; i++) {
            if (nums[i] == target) {
                count++;
                if (rng.Next(count) == 0) {
                    res = i;
                }
            }
        }
        return res;
    }
}
