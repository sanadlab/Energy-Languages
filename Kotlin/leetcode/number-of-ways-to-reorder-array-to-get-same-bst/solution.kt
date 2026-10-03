class Solution {
    private val MOD = 1_000_000_007L
    private lateinit var C: Array<LongArray>

    fun numOfWays(nums: IntArray): Int {
        val n = nums.size
        C = Array(n + 1) { LongArray(n + 1) }
        for (i in 0..n) {
            C[i][0] = 1
            for (j in 1..i) {
                C[i][j] = (C[i - 1][j - 1] + C[i - 1][j]) % MOD
            }
        }
        val res = (ways(nums.toList()) - 1 + MOD) % MOD
        return res.toInt()
    }

    private fun ways(arr: List<Int>): Long {
        val m = arr.size
        if (m <= 2) return 1L
        val root = arr[0]
        val left = ArrayList<Int>()
        val right = ArrayList<Int>()
        for (idx in 1 until m) {
            val x = arr[idx]
            if (x < root) left.add(x) else if (x > root) right.add(x)
        }
        return C[m - 1][left.size] * ways(left) % MOD * ways(right) % MOD
    }
}
