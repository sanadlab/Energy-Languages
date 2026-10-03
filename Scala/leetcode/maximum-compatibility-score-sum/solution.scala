object Solution {
    def maxCompatibilitySum(students: Array[Array[Int]], mentors: Array[Array[Int]]): Int = {
        val m = students.length
        val n = if (m > 0) students(0).length else 0
        val score = Array.ofDim[Int](m, m)
        for (i <- 0 until m; j <- 0 until m) {
            score(i)(j) = (0 until n).count(k => students(i)(k) == mentors(j)(k))
        }
        val dp = Array.fill(1 << m)(0)
        for (mask <- 0 until (1 << m)) {
            val i = Integer.bitCount(mask)
            if (i < m) {
                for (j <- 0 until m if ((mask >> j) & 1) == 0) {
                    val nm = mask | (1 << j)
                    val v = dp(mask) + score(i)(j)
                    if (v > dp(nm)) dp(nm) = v
                }
            }
        }
        dp((1 << m) - 1)
    }
}
