class Solution {
    fun canCross(stones: IntArray): Boolean {
        if (stones[1] != 1) {
            return false
        }

        val stoneSet = stones.toHashSet()
        val dp = HashMap<Int, HashSet<Int>>()
        for (stone in stones) {
            dp[stone] = HashSet()
        }

        dp[1]!!.add(1)

        for (stone in stones) {
            for (k in dp[stone]!!) {
                for (step in intArrayOf(k - 1, k, k + 1)) {
                    if (step > 0 && (stone + step) in stoneSet) {
                        dp[stone + step]!!.add(step)
                    }
                }
            }
        }

        return dp[stones[stones.size - 1]]!!.isNotEmpty()
    }
}
