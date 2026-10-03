class Solution {
    fun maxCompatibilitySum(students: Array<IntArray>, mentors: Array<IntArray>): Int {
        val m = students.size
        val n = if (m > 0) students[0].size else 0
        val score = Array(m) { IntArray(m) }
        for (i in 0 until m) {
            for (j in 0 until m) {
                var s = 0
                for (k in 0 until n) if (students[i][k] == mentors[j][k]) s++
                score[i][j] = s
            }
        }
        val dp = IntArray(1 shl m)
        for (mask in 0 until (1 shl m)) {
            val i = Integer.bitCount(mask)
            if (i >= m) continue
            for (j in 0 until m) {
                if ((mask shr j) and 1 == 1) continue
                val nm = mask or (1 shl j)
                val v = dp[mask] + score[i][j]
                if (v > dp[nm]) dp[nm] = v
            }
        }
        return dp[(1 shl m) - 1]
    }
}
