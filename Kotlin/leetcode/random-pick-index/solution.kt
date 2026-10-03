class Solution(nums: IntArray) {

    private val nums = nums

    fun pick(target: Int): Int {
        var count = 0
        var res = -1
        for (i in nums.indices) {
            if (nums[i] == target) {
                count++
                if (kotlin.random.Random.nextInt(count) == 0) {
                    res = i
                }
            }
        }
        return res
    }

}

/**
 * Your Solution object will be instantiated and called as such:
 * var obj = Solution(nums)
 * var param_1 = obj.pick(target)
 */
