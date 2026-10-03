class Solution {
    fun maxScore(nums: IntArray): Int {
        val m = nums.size
        val dp = IntArray(1 shl m)
        var best = 0
        for (mask in 0 until (1 shl m)) {
            val cnt = Integer.bitCount(mask)
            if (cnt and 1 == 1) continue
            val op = cnt / 2 + 1
            for (i in 0 until m) {
                if ((mask shr i) and 1 == 1) continue
                for (j in i + 1 until m) {
                    if ((mask shr j) and 1 == 1) continue
                    val nm = mask or (1 shl i) or (1 shl j)
                    val v = dp[mask] + op * gcd(nums[i], nums[j])
                    if (v > dp[nm]) {
                        dp[nm] = v
                        if (v > best) best = v
                    }
                }
            }
        }
        return best
    }

    private fun gcd(a: Int, b: Int): Int {
        var x = a
        var y = b
        while (y != 0) {
            val t = x % y
            x = y
            y = t
        }
        return x
    }
}
