public class Solution {
    public int[] Shuffle(int[] nums, int n) {
        int m = nums.Length / 2;
        int[] res = new int[2 * m];
        for (int i = 0; i < m; i++) {
            res[2 * i] = nums[i];
            res[2 * i + 1] = nums[i + m];
        }
        return res;
    }
}
