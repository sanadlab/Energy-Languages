class Solution {
    fun countMaxOrSubsets(nums: IntArray): Int {
        var maxOr = 0
        for (num in nums) {
            maxOr = maxOr or num
        }

        val n = nums.size
        var count = 0
        for (mask in 1 until (1 shl n)) {
            var cur = 0
            for (i in 0 until n) {
                if (mask and (1 shl i) != 0) {
                    cur = cur or nums[i]
                }
            }
            if (cur == maxOr) {
                count++
            }
        }
        return count
    }
}
