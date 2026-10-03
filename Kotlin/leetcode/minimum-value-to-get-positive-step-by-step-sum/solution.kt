class Solution {
    fun minStartValue(nums: IntArray): Int {
        var prefix = 0
        var minPrefix = 0
        for (x in nums) {
            prefix += x
            if (prefix < minPrefix) minPrefix = prefix
        }
        return maxOf(1, 1 - minPrefix)
    }
}
