class Solution {
    fun nextGreaterElements(nums: IntArray): IntArray {
        val n = nums.size
        val res = IntArray(n) { -1 }
        val st = ArrayDeque<Int>()
        for (i in 0 until 2 * n) {
            val cur = nums[i % n]
            while (st.isNotEmpty() && nums[st.last()] < cur) {
                res[st.removeLast()] = cur
            }
            if (i < n) st.addLast(i)
        }
        return res
    }
}
