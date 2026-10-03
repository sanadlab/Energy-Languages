class Solution {
    fun shuffle(nums: IntArray, n: Int): IntArray {
        val m = nums.size / 2
        val res = IntArray(nums.size)
        var idx = 0
        for (i in 0 until m) {
            res[idx++] = nums[i]
            res[idx++] = nums[i + m]
        }
        return res
    }
}
