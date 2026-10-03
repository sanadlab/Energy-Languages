class Solution {
    fun numFactoredBinaryTrees(arr: IntArray): Int {
        arr.sort()
        val MOD = 1_000_000_007L
        val dp = HashMap<Int, Long>()
        for (i in arr.indices) {
            val v = arr[i]
            var cnt = 1L
            for (j in 0 until i) {
                val a = arr[j]
                if (v % a == 0) {
                    val b = v / a
                    val db = dp[b]
                    if (db != null) {
                        cnt = (cnt + dp[a]!! * db) % MOD
                    }
                }
            }
            dp[v] = cnt % MOD
        }
        var total = 0L
        for (value in dp.values) {
            total = (total + value) % MOD
        }
        return total.toInt()
    }
}
