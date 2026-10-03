object Solution {
    def maxScore(nums: Array[Int]): Int = {
        val m = nums.length
        val dp = Array.fill(1 << m)(0)
        var best = 0
        def gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)
        for (mask <- 0 until (1 << m)) {
            val cnt = Integer.bitCount(mask)
            if ((cnt & 1) == 0) {
                val op = cnt / 2 + 1
                for (i <- 0 until m) {
                    if (((mask >> i) & 1) == 0) {
                        for (j <- (i + 1) until m) {
                            if (((mask >> j) & 1) == 0) {
                                val nm = mask | (1 << i) | (1 << j)
                                val v = dp(mask) + op * gcd(nums(i), nums(j))
                                if (v > dp(nm)) {
                                    dp(nm) = v
                                    if (v > best) best = v
                                }
                            }
                        }
                    }
                }
            }
        }
        best
    }
}
