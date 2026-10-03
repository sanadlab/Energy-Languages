class Solution {
    fun minSubsequence(nums: IntArray): List<Int> {
        val sorted = nums.sortedDescending()
        val total = sorted.sum()
        var running = 0
        val res = mutableListOf<Int>()
        for (x in sorted) {
            running += x
            res.add(x)
            if (running * 2 > total) break
        }
        return res
    }
}
