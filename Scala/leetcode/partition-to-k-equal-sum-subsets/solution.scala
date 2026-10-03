object Solution {
    def canPartitionKSubsets(nums: Array[Int], k: Int): Boolean = {
        if (k <= 0 || nums.length < k) return false
        val total = nums.sum
        if (total % k != 0) return false
        val target = total / k
        val arr = nums.sortWith(_ > _)
        if (arr(0) > target) return false
        val n = arr.length
        val used = Array.fill(n)(false)

        def backtrack(kk: Int, cur: Int, start: Int): Boolean = {
            if (kk == 0) return true
            if (cur == target) return backtrack(kk - 1, 0, 0)
            var i = start
            while (i < n) {
                if (!used(i) && cur + arr(i) <= target) {
                    used(i) = true
                    if (backtrack(kk, cur + arr(i), i + 1)) return true
                    used(i) = false
                    if (cur == 0) return false
                }
                i += 1
            }
            false
        }

        backtrack(k, 0, 0)
    }
}
