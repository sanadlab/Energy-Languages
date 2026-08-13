class Solution {
    public int minStartValue(int[] nums) {
        int prefix = 0, minPrefix = 0;
        for (int x : nums) {
            prefix += x;
            if (prefix < minPrefix) minPrefix = prefix;
        }
        return Math.max(1, 1 - minPrefix);
    }
}
