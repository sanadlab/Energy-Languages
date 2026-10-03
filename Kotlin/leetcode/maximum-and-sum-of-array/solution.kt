class Solution {
    fun maximumANDSum(nums: IntArray, numSlots: Int): Int {
        val n = nums.size
        val full = (1 shl n) - 1
        var dp = IntArray(1 shl n) { -1 }
        dp[0] = 0
        for (slot in 1..numSlots) {
            val ndp = dp.copyOf()
            for (mask in 0 until (1 shl n)) {
                if (dp[mask] < 0) continue
                val base = dp[mask]
                for (i in 0 until n) {
                    if ((mask shr i) and 1 == 1) continue
                    val nm = mask or (1 shl i)
                    val v = base + (nums[i] and slot)
                    if (v > ndp[nm]) ndp[nm] = v
                    for (j in i + 1 until n) {
                        if ((mask shr j) and 1 == 1) continue
                        val nm2 = nm or (1 shl j)
                        val v2 = v + (nums[j] and slot)
                        if (v2 > ndp[nm2]) ndp[nm2] = v2
                    }
                }
            }
            dp = ndp
        }
        return if (dp[full] >= 0) dp[full] else 0
    }
}
