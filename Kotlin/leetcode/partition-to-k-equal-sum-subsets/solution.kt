class Solution {
    private lateinit var arr: IntArray
    private lateinit var used: BooleanArray
    private var target = 0
    private var n = 0

    fun canPartitionKSubsets(nums: IntArray, k: Int): Boolean {
        if (k <= 0 || nums.size < k) return false
        val total = nums.sum()
        if (total % k != 0) return false
        target = total / k
        val sorted = nums.sortedDescending().toIntArray()
        if (sorted[0] > target) return false
        arr = sorted
        n = sorted.size
        used = BooleanArray(n)
        return backtrack(k, 0, 0)
    }

    private fun backtrack(k: Int, cur: Int, start: Int): Boolean {
        if (k == 0) return true
        if (cur == target) return backtrack(k - 1, 0, 0)
        for (i in start until n) {
            if (used[i] || cur + arr[i] > target) continue
            used[i] = true
            if (backtrack(k, cur + arr[i], i + 1)) return true
            used[i] = false
            if (cur == 0) break
        }
        return false
    }
}
