public class Solution {
    public int MinStartValue(int[] nums) {
        int prefix = 0, minPrefix = 0;
        foreach (int x in nums) {
            prefix += x;
            if (prefix < minPrefix) minPrefix = prefix;
        }
        return Math.Max(1, 1 - minPrefix);
    }
}
