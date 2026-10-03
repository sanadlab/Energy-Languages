import kotlin.math.abs

class Solution {
    fun findKDistantIndices(nums: IntArray, key: Int, k: Int): List<Int> {
        val result = ArrayList<Int>()
        for (i in nums.indices) {
            var found = false
            for (j in nums.indices) {
                if (abs(i - j) <= k && nums[j] == key) {
                    found = true
                    break
                }
            }
            if (found) {
                result.add(i)
            }
        }
        return result
    }
}
