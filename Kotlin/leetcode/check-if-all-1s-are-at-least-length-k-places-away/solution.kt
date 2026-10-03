class Solution {
    fun kLengthApart(nums: IntArray, k: Int): Boolean {
        var prev = -1
        for (i in nums.indices) {
            if (nums[i] == 1) {
                if (prev != -1 && i - prev - 1 < k) return false
                prev = i
            }
        }
        return true
    }
}
